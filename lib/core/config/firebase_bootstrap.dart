import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  /// Initializes Firebase when native Firebase config has been added.
  ///
  /// Android config expected later:
  /// - android/app/google-services.json
  ///
  /// iOS config expected later:
  /// - ios/Runner/GoogleService-Info.plist
  ///
  /// This intentionally does not crash the app while the Firebase project files
  /// are still being prepared. Auth calls will still require Firebase to be
  /// configured before they can succeed.
  static Future<bool> initializeIfConfigured() async {
    if (Firebase.apps.isNotEmpty) return true;

    try {
      await Firebase.initializeApp();
      return true;
    } on FirebaseException catch (error, stackTrace) {
      if (error.code == 'duplicate-app') return true;

      debugPrint('Firebase is not configured yet: ${error.message}');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    } catch (error, stackTrace) {
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}
