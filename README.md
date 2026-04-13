# CoinFlow

A minimal, offline-first Flutter expense tracker focused on fast entry and a clean home dashboard.

## Features

- 2-tap add flow: tap the FAB, type an amount, tap a category to save
- Local-only persistence with Hive
- Home dashboard with today's total, recent expenses, and category insight
- Beginner-friendly structure with simple Provider state management
- iOS-safe dependency choices

## Project Structure

```text
lib/
  main.dart
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
test/
```

## Run On Windows (Android)

1. Install the latest stable Flutter SDK and Android Studio.
2. Start an Android emulator from Android Studio.
3. Open a terminal in the project root:

   ```powershell
   cd personal_money_tracker
   flutter create . --platforms=android,ios
   flutter pub get
   flutter run
   ```

4. If more than one device is available, run:

   ```powershell
   flutter devices
   flutter run -d <device-id>
   ```

## Transfer To macOS

1. Copy the full `personal_money_tracker` folder to your Mac or push it to Git and clone it there.
2. Install the latest stable Flutter SDK, Xcode, and CocoaPods.
3. In Terminal on macOS:

   ```bash
   cd personal_money_tracker
   flutter create . --platforms=ios,android
   flutter pub get
   flutter doctor
   ```

4. Resolve any missing Xcode or CocoaPods items reported by `flutter doctor`.

## Build And Run On iOS

1. Generate iOS dependencies and the Xcode workspace:

   ```bash
   flutter build ios
   open ios/Runner.xcworkspace
   ```

2. In Xcode:
   - Select the `Runner` target.
   - Set your Signing Team in `Signing & Capabilities`.
   - Choose an iPhone simulator or connected device.
   - Press Run.

3. You can also run directly from Terminal:

   ```bash
   flutter run -d ios
   ```

## Notes

- This workspace did not have the Flutter SDK installed, so native platform folders were not generated here.
- Running `flutter create . --platforms=android,ios` inside this folder will create or refresh the standard Flutter platform scaffolding without replacing the app code in `lib/`.
