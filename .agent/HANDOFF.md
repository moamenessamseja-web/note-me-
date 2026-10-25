# HANDOFF.md — For Next Session

## Quick Start
```bash
cd /root/projects/moamenessamseja-web__note-me-
git status
git log --oneline -3
```

## What to Test NOW

**Build APK:**
```bash
# Check if workflow already ran, or trigger manually:
gh workflow run "Build APK"
```

**Or use the provided CI script if available.**

---

## What Was Done

| Item | Status | How Verified |
|------|--------|--------------|
| Fixed vault bug in EditorScreen | ✅ Done | Code inspection |
| Fixed pubspec.yaml | ✅ Done | YAML valid |
| Created .agent/ memory | ✅ Done | Files written |
| Initialized git repo | ✅ Done | git status clean |

---

## What Was NOT Verified (CI needed)

- `flutter analyze --no-fatal-infos` — runs in CI
- `flutter build apk --release` — produces APK
- Vault encryption round-trip
- All screens render correctly

---

## What NOT to Do

1. **Don't push directly to main** — work on a feature branch
2. **Don't assume font files exist** — removed Tajawal from pubspec
3. **Don't re-create the vault bug** — the `if (_vault)` branch now calls `VaultService.saveVaultNote()`, not `deleteNote()`

---

## Key Files

| File | Why It Matters |
|------|----------------|
| `lib/screens/editor_screen.dart` | Fixed vault bug (line ~119-157) |
| `lib/services/vault_service.dart` | AES/CBC/256 encryption, PBKDF2 key derivation |
| `pubspec.yaml` | Fixed duplicate flutter: keys, removed missing fonts |

---

## Environment

- **Flutter version:** 3.47.7 (from GitHub workflow)
- **Dart SDK:** >=3.4.0 <4.0.0
- **Key dependencies:** shared_preferences, markdown, html, uuid, path_provider, encrypt
