# Firebase Auth Setup

This app is structured to use **Firebase Authentication only** while keeping the real backend on **Railway**.

## Current App Structure

Auth-related files:

```txt
lib/core/config/app_config.dart
lib/core/config/firebase_bootstrap.dart
lib/core/network/api_exception.dart
lib/core/network/railway_api_client.dart
lib/features/auth/domain/app_user.dart
lib/features/auth/domain/auth_repository.dart
lib/features/auth/data/firebase_auth_repository.dart
lib/features/auth/presentation/auth_controller.dart
```

Packages added:

```yaml
firebase_core
firebase_auth
google_sign_in
sign_in_with_apple
http
crypto
```

## Important Package ID Note

The Android package/application ID is now:

```txt
com.rityxtech.smclient
```

Firebase Android apps are tied to this package ID. Use this exact value when creating the Android app in Firebase Console.

## Firebase Console Steps

1. Go to Firebase Console.
2. Create a Firebase project.
3. Add an Android app.
4. Use the app package ID from `android/app/build.gradle.kts`:

```kotlin
applicationId = "com.rityxtech.smclient"
```

5. Download `google-services.json`.
6. Place it here:

```txt
android/app/google-services.json
```

7. Enable Authentication providers:
   - Email/password
   - Google
   - Apple later for iOS

## Google Sign-In SHA Fingerprints

For Google Sign-In on Android, add your debug SHA fingerprints to Firebase.

Run:

```sh
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
```

Copy the `SHA1` and `SHA-256` values into:

```txt
Firebase Console > Project Settings > Your Android App > SHA certificate fingerprints
```

Then download the updated `google-services.json` again and replace the file in:

```txt
android/app/google-services.json
```

## Android Gradle Setup

The project already contains a conditional Google Services plugin setup:

```kotlin
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}
```

This means:

- The project still builds before Firebase config exists.
- Once `android/app/google-services.json` is added, Gradle automatically applies the Firebase Google Services plugin.

## App Startup

Firebase initialization is handled by:

```txt
lib/core/config/firebase_bootstrap.dart
```

`main.dart` calls:

```dart
await FirebaseBootstrap.initializeIfConfigured();
```

Before Firebase config exists, the app continues running. After config exists, Firebase initializes normally.

## Railway Backend Token Flow

After a user signs in with Firebase, the app can call your Railway backend with a Firebase ID token:

```http
Authorization: Bearer FIREBASE_ID_TOKEN
```

The reusable client is:

```txt
lib/core/network/railway_api_client.dart
```

It automatically attaches the current Firebase user's ID token when Firebase is configured and a user is signed in.

Set your Railway API base URL when running the app:

```sh
flutter run --dart-define=RAILWAY_API_BASE_URL=https://your-api.up.railway.app
```

In production builds:

```sh
flutter build apk --release --dart-define=RAILWAY_API_BASE_URL=https://your-api.up.railway.app
```

## Backend Verification

On Railway, every protected endpoint should:

1. Read the `Authorization` header.
2. Extract the bearer token.
3. Verify it using Firebase Admin SDK.
4. Trust the verified Firebase `uid` as the authenticated user ID.
5. Use that `uid` to query your Railway database.

Example user mapping:

```txt
firebase_uid: "abc123"
email: "user@gmail.com"
name: "John Doe"
provider: "google.com"
```

## Next App Wiring Steps

After `google-services.json` is added and Auth providers are enabled:

1. Wire `LoginScreen` email/password button to `FirebaseAuthRepository.signInWithEmailAndPassword`.
2. Wire Google button to `FirebaseAuthRepository.signInWithGoogle`.
3. Wire register screen to `FirebaseAuthRepository.createUserWithEmailAndPassword`.
4. Wire forgot password to `sendPasswordResetEmail`.
5. On successful auth, navigate to `MainShell`.
6. On app launch, use auth state to decide whether to show `LoginScreen` or `MainShell`.
