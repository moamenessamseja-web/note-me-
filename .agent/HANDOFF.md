# HANDOFF (cold start, 2026-10-27)

**Test/trust target:** release `build-16` (commit fc21d08, branch `recovery/flutter-repair`). CI green: analyze + tests + release APK. NOT device-tested.
**Distrust:** everything on `main` (702df83): CI red (runs 5, 13, 14). Old docs claiming "Verified complete / 47 tests" were false (see IMPLEMENTATION_STATE).
**Anchors:** tag `baseline-run14-red` = 702df83 (state before recovery).

## Work now
1. Owner installs `build-16` APK, tests: create note, edit, reopen app, open reader (Markdown must render, not show tags), search, delete.
2. Owner decides merge of `recovery/flutter-repair` into `main` (agent never merges before device confirmation).
3. Next engineering: editor Markdown toolbar/preview, fix 5 deprecated APIs, bundle Tajawal font, reader tab with no note.

## Do not
- Do not restore reminder/notification/rules stubs (deleted, dead code, no plugin).
- Do not add google_fonts/INTERNET permission without a decision (app is offline-first; none needed today).
- Do not mark anything "Verified" without device or CI evidence (see implementation.md).
- Never write the owner's GitHub token anywhere.
