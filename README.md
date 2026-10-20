# Tailor Records

Local-first customer measurement records for tailors (Android).

## OTA updates (GitHub Releases)

Releases are built when you push a version tag. The app checks the latest public release and can download `TailorRecords.apk`.

### Ship a new version

1. Bump `version` in `pubspec.yaml` (increase the number after `+` every release, e.g. `1.0.1+2`).
2. Commit and push to `main`.
3. Tag and push:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```
4. GitHub Actions (`.github/workflows/android-release.yml`) builds the APK and publishes `TailorRecords.apk` + `ota.json` on the release.

### Release signing (recommended)

Without a release keystore, CI signs with the **debug** key. OTA only works if every installed APK uses the **same** certificate.

1. Create a keystore (keep it out of git):
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Copy `android/key.properties.example` to `android/key.properties` and fill in passwords.
3. Add GitHub repository secrets: `KEYSTORE_BASE64` (base64 of the `.jks` file), `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`.

### Verify OTA manually

1. Install build `+N` on a device (sideload the release APK).
2. Ship `+N+1` via a new tag.
3. Open the app → accept the update prompt or use **Settings → Check for update**.
4. Confirm the installer overlays the app and local customer data is still present.
