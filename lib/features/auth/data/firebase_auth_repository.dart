import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuth get _auth {
    _ensureFirebaseConfigured();
    return _firebaseAuth ?? FirebaseAuth.instance;
  }

  @override
  Stream<AppUser?> get authStateChanges {
    if (!_isFirebaseConfigured) return const Stream<AppUser?>.empty();
    return _auth.authStateChanges().map(
          (user) => user == null ? null : AppUser.fromFirebaseUser(user),
        );
  }

  @override
  AppUser? get currentUser {
    if (!_isFirebaseConfigured) return null;
    final user = _auth.currentUser;
    return user == null ? null : AppUser.fromFirebaseUser(user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _requireUser(credential.user);
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw StateError(
          'Firebase did not return a user after account creation.');
    }

    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      await user.updateDisplayName(trimmedName);
      await user.reload();
    }

    return AppUser.fromFirebaseUser(_auth.currentUser ?? user);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(provider);
      return _requireUser(credential.user);
    }

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw StateError('sign_in_canceled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _requireUser(userCredential.user);
  }

  @override
  Future<AppUser> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256OfString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    final user = _requireFirebaseUser(userCredential.user);

    final fullName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ]
        .where((namePart) => namePart != null && namePart.trim().isNotEmpty)
        .join(' ');

    if ((user.displayName == null || user.displayName!.trim().isEmpty) &&
        fullName.trim().isNotEmpty) {
      await user.updateDisplayName(fullName.trim());
      await user.reload();
    }

    return AppUser.fromFirebaseUser(_auth.currentUser ?? user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    if (!_isFirebaseConfigured) return null;
    return _auth.currentUser?.getIdToken(forceRefresh);
  }

  @override
  Future<void> signOut() async {
    if (!_isFirebaseConfigured) return;
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  AppUser _requireUser(User? user) {
    return AppUser.fromFirebaseUser(_requireFirebaseUser(user));
  }

  User _requireFirebaseUser(User? user) {
    if (user == null) {
      throw StateError('Firebase did not return a user.');
    }
    return user;
  }

  bool get _isFirebaseConfigured => Firebase.apps.isNotEmpty;

  void _ensureFirebaseConfigured() {
    if (!_isFirebaseConfigured) {
      throw StateError('firebase-not-configured');
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
