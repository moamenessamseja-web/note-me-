# implementation.md — Feature & Inventory

## Status Legend
- Verified complete — CI green + artifact inspected
- 🔄 **Implemented, not yet verified** — code present, CI not confirmed
- ⚠️ **Partially implemented** — stub / in-progress
- ❌ **Not started**
- 🚫 **Deferred by product decision**

---

## Screens
| Feature | Status | Notes |
|---|---|---|
| MainShell (10-tab nav) | Implemented, not yet verified | Bottom nav + drawer; IndexedStack |
| HomeScreen | Implemented, not yet verified | Search bar, category chips, note list |
| NotesScreen | Implemented, not yet verified | Sort + filter, note list |
| EditorScreen | Implemented, not yet verified | Save, vault toggle, category, tags |
| ReaderScreen | Implemented, not yet verified | Native renderer MarkdownView; CI widget tests green (run 16); not device-tested |
| SearchScreen | Implemented, not yet verified | Full-text search across notes |
| CategoriesScreen | Implemented, not yet verified | Expandable category tree with notes |
| ThemesScreen | Implemented, not yet verified | Light/Dark/System radio |
| VaultScreen | Implemented, not yet verified | AES/CBC encryption via pointycastle |
| SettingsScreen | Implemented, not yet verified | Theme, language, font size, backup stub |
| AboutScreen | Implemented, not yet verified | Version, description, license |

## Services
| Feature | Status | Notes |
|---|---|---|
| StorageService | Implemented, not yet verified | SharedPreferences with serialization + error handling |
| VaultService | Implemented, not yet verified | PBKDF2 + AES/CBC/PKCS7; base64 storage |
| SettingsService | Implemented, not yet verified | Theme, font size, language persistence |
| AppState (ValueNotifier) | Implemented, not yet verified | Reactive state for rebuilds |
| AppErrorService | Implemented, not yet verified | Diagnostic log + user messages |

## Models
| Feature | Status | Notes |
|---|---|---|
| Note | Implemented, not yet verified | JSON serialization, copyWith, preview getter |
| Category | Implemented, not yet verified | JSON serialization, copyWith |

## Design System
| Feature | Status | Notes |
|---|---|---|
| tokens.dart (AppColors, AppSpace, AppRadius, AppText) | Implemented, not yet verified | All Material 3, Cairo/Tajawal font |
| app_theme.dart (ThemeData light/dark) | Implemented, not yet verified | Used in main.dart |
| strings.dart (L — Arabic/English) | Implemented, not yet verified | 60+ keys, RTL support |

## CI / Build
| Feature | Status | Notes |
|---|---|---|
| build.yml (APK) | 🔄 Implemented, not yet verified | Flutter 3.47.7, analyze, test, APK |
| dart.yml (CI checks) | 🔄 Implemented, not yet verified | Static analysis only |
| ProGuard rules | Implemented, not yet verified | Gson + flutter_local_notifications |
| AndroidManifest (permissions + boot receiver) | Implemented, not yet verified | Injected by workflow |

## Out of Scope (Frozen)
- Google sign-in — stub only, not implemented
- Cloud backup — localStorage only
- Live Gemini integration tests — tagged `live`, skipped in CI


## Verification log (2026-10-27)
| Build | Commit | CI | Device |
|---|---|---|---|
| build-15 | b302149 | green (analyze, tests, APK) | not tested |
| build-16 | fc21d08 | green (analyze, tests incl. markdown, APK) | not tested |
| build-17 | 2906bb2 | green (editor error handling; no editor test) | not tested |

Removed 2026-10-27: Notification/Reminder/Rules services (dead stubs, no plugin).
