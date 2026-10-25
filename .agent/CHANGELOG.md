# CHANGELOG.md

## 2026-10-25 — Session Baseline

### Fixed
- **CRITICAL: EditorScreen vault bug** — When vault=true, note was being deleted instead of encrypted. Now correctly calls `VaultService.saveVaultNote()`.
- **pubspec.yaml** — Removed duplicate `flutter:` keys and non-existent Tajawal font references.

### Added
- **`.agent/` memory** — IMPLEMENTATION_STATE.md and HANDOFF.md for session continuity.
- **VaultService import** to editor_screen.dart.

### Notes
- Project has NO prior git history — this is the initial commit baseline.
- Build has NOT been verified in CI yet — need to dispatch workflow.
