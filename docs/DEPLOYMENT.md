# DEPLOYMENT.md - Supri POS Deployment Strategy

## 1. Development Environment
* Running local emulator/simulator.
* To run development builds:
  ```bash
  flutter pub get
  ```
  ```bash
  flutter run --debug
  ```

## 2. Production Builds
Build final release packages optimized for store publication.

* **Android (Build App Bundle):**
  ```bash
  flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
  ```
* **iOS (Build IPA Archive):**
  ```bash
  flutter build ipa --release --obfuscate --split-debug-info=build/ios/outputs/symbols
  ```

## 3. Play Store & App Store Pipelines
* Use **Fastlane** to automate screenshots capturing, beta deployment (TestFlight & Google Play Internal Test), and production releases.
* Setup Github Actions workflows to run static analysis (`flutter analyze`), unit tests (`flutter test`), and trigger Fastlane builds upon pushing tags.
