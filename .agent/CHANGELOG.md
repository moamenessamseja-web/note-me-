# CHANGELOG.md

## 2026-10-26 — Session Fix + CI Verification
### Fixed
- **CRITICAL: main.dart missing app_theme import** — `AppTheme.light()` / `AppTheme.dark()` called but import removed. Restored.
- **vault_service.dart: duplicate import + unnecessary casts** — cleaned up.
- **settings_service.dart: unused `_initialized` field** — removed.
- **Screens: unused `app_theme.dart` imports** — correctly removed (screens use tokens.dart only).
### Updated
- **.agent/implementation.md** — Created (feature inventory).
- **.agent/IMPLEMENTATION_STATE.md** — Dated session section.
- **.agent/HANDOFF.md** — Updated.
### CI
- **CI build: PENDING** — pushed to `main`, `build.yml` queued.

---

## 2026-10-26 — Session Update (prior)
### Updated
- **README.md** — Replaced with mindbook-pro reference README
- **Session** — README replaced, preparing for CI verification

## 2026-10-25 — Session Baseline
### Fixed
- **CRITICAL: EditorScreen vault bug** — When vault=true, note was deleted instead of encrypted.
- **pubspec.yaml** — Removed duplicate flutter: keys and non-existent Tajawal font references.
### Added
- **.agent/ memory** — IMPLEMENTATION_STATE.md and HANDOFF.md
- **VaultService import** to editor_screen.dart

## 2026-10-27
- fix(ci) b302149: removed 2 unused imports + missing assets/ decl (the 3 analyzer WARNINGS that failed run 14); removed unused deps (html, uuid, path_provider, encrypt, google_fonts) and dead stubs (reminder/notification/rules services); deleted dart.yml (Dart-package workflow cannot analyze a Flutter app); rewrote build.yml (was copied from manager-assistant). Added test/note_test.dart, test/storage_test.dart. Run 15: GREEN (build-15).
- feat(reader) fc21d08: native Markdown renderer (lib/widgets/markdown_view.dart); reader previously showed raw HTML text. Added test/markdown_view_test.dart. Run 16: GREEN (build-16).
- fix(editor) 2906bb2: save errors now caught/logged/shown (was silent StateError when vault locked); leaving the vault deletes the encrypted duplicate; tags field prefilled on edit; root README replaced (old one described a React app, archived). Run 17: GREEN (build-17).
