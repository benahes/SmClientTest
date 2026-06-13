import 'package:flutter/foundation.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) {
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user ?? _authRepository.currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => user != null;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(() async {
      _user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    await _runAuthAction(() async {
      _user = await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    await _runAuthAction(() async {
      _user = await _authRepository.signInWithGoogle();
    });
  }

  Future<void> signInWithApple() async {
    await _runAuthAction(() async {
      _user = await _authRepository.signInWithApple();
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _runAuthAction(() => _authRepository.sendPasswordResetEmail(email));
  }

  Future<void> signOut() async {
    await _runAuthAction(() async {
      await _authRepository.signOut();
      _user = null;
    });
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await action();
    } catch (error) {
      _errorMessage = _friendlyError(error);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('firebase-not-configured')) {
      return 'Firebase is not configured yet.';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    if (message.contains('user-not-found') ||
        message.contains('wrong-password')) {
      return 'Invalid email or password.';
    }
    if (message.contains('email-already-in-use')) {
      return 'An account already exists for this email.';
    }
    if (message.contains('popup-closed-by-user') ||
        message.contains('sign_in_canceled')) {
      return 'Sign-in was cancelled.';
    }
    return 'Authentication failed. Please try again.';
  }
}
