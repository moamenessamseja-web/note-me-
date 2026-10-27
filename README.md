# Note Me

Offline-first Markdown notebook for Android, written in Flutter/Dart. Inspired by *Notebook Pro / Mindbook Pro: Markdown Notes*; it is an independent re-creation, **not** an official version of that app.

## Features (see `.agent/implementation.md` for the honest status of each)
Notes (create / edit / delete / pin), Markdown reader (native widgets, no WebView), categories, search, sort, encrypted vault (PBKDF2 + AES-CBC), light/dark themes, Arabic (RTL) and English UI, local storage via `shared_preferences`.

## Build and run
Requires Flutter 3.47.7 (the version CI pins) and an Android SDK.
```bash
flutter create --platforms=android --org app.noteme --project-name note_me .   # android/ is generated, not committed
rm -f test/widget_test.dart
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter run                      # device/emulator
flutter build apk --release      # build/app/outputs/flutter-apk/app-release.apk
```
CI (`.github/workflows/build.yml`, manual `workflow_dispatch`) does the same and publishes the APK as a GitHub release `build-<run>`.

## Notes
- Release APKs from CI are signed with a debug key; a fixed keystore is required before any store release.
- Engineering memory for contributors/agents: `.agent/` (start with `HANDOFF.md`).
