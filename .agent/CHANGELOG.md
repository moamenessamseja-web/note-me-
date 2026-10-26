# CHANGELOG.md

## 2026-10-26 — Session Update
### Updated
- **README.md** — Replaced with mindbook-pro reference README (full feature list, architecture, design notes)
- **Session** — README replaced, preparing for CI verification

## 2026-10-25 — Session Baseline
### Fixed
- **CRITICAL: EditorScreen vault bug** — When vault=true, note was deleted instead of encrypted.
- **pubspec.yaml** — Removed duplicate flutter: keys and non-existent Tajawal font references.
### Added
- **.agent/ memory** — IMPLEMENTATION_STATE.md and HANDOFF.md
- **VaultService import** to editor_screen.dart