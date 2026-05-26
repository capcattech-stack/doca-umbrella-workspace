# Android Release Checklist (Google Play)

## 1) Required before first upload

1. Set production package id in `android/app/build.gradle.kts`:
   - `applicationId = "your.real.package.id"`
   - `namespace = "your.real.package.id"`
2. Update Kotlin package path to match namespace:
   - `android/app/src/main/kotlin/.../MainActivity.kt`
3. Create upload keystore:
   - Example:
     ```bash
     keytool -genkeypair -v -keystore keystore/upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
     ```
4. Create `android/key.properties` from `android/key.properties.example`.
5. Update Firebase Android app:
   - Add the new package id.
   - Add SHA-1/SHA-256 of release keystore.
   - Download and replace `android/app/google-services.json`.

## 2) Versioning

1. Update `pubspec.yaml`:
   - `version: x.y.z+buildNumber`
2. Increase `buildNumber` for every release.

## 3) Build and verify

1. Build AAB:
   ```bash
   flutter build appbundle --release
   ```
2. Output:
   - `build/app/outputs/bundle/release/app-release.aab`

## 4) Play Console setup

1. App content / Data safety
2. Privacy policy URL
3. Content rating
4. App access (if login required)
5. Store listing assets (icon, feature graphic, screenshots)
6. Internal testing rollout first, then production.

