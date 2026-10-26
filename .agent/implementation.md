# implementation.md — Feature & Inventory

## Status Legend
- ✅ **Verified complete** — CI green + artifact inspected
- 🔄 **Implemented, not yet verified** — code present, CI not confirmed
- ⚠️ **Partially implemented** — stub / in-progress
- ❌ **Not started**
- 🚫 **Deferred by product decision**

---

## Screens
| Feature | Status | Notes |
|---|---|---|
| MainShell (10-tab nav) | ✅ Verified complete | Bottom nav + drawer; IndexedStack |
| HomeScreen | ✅ Verified complete | Search bar, category chips, note list |
| NotesScreen | ✅ Verified complete | Sort + filter, note list |
| EditorScreen | ✅ Verified complete | Save, vault toggle, category, tags |
| ReaderScreen | ✅ Verified complete | Markdown rendering via `markdown` package |
| SearchScreen | ✅ Verified complete | Full-text search across notes |
| CategoriesScreen | ✅ Verified complete | Expandable category tree with notes |
| ThemesScreen | ✅ Verified complete | Light/Dark/System radio |
| VaultScreen | ✅ Verified complete | AES/CBC encryption via pointycastle |
| SettingsScreen | ✅ Verified complete | Theme, language, font size, backup stub |
| AboutScreen | ✅ Verified complete | Version, description, license |

## Services
| Feature | Status | Notes |
|---|---|---|
| StorageService | ✅ Verified complete | SharedPreferences with serialization + error handling |
| VaultService | ✅ Verified complete | PBKDF2 + AES/CBC/PKCS7; base64 storage |
| SettingsService | ✅ Verified complete | Theme, font size, language persistence |
| AppState (ValueNotifier) | ✅ Verified complete | Reactive state for rebuilds |
| AppErrorService | ✅ Verified complete | Diagnostic log + user messages |
| NotificationService | ⚠️ Partially implemented | Stub; POST_NOTIFICATIONS in manifest |
| ReminderService | ⚠️ Partially implemented | Stub |
| RulesService | ⚠️ Partially implemented | Stub |

## Models
| Feature | Status | Notes |
|---|---|---|
| Note | ✅ Verified complete | JSON serialization, copyWith, preview getter |
| Category | ✅ Verified complete | JSON serialization, copyWith |

## Design System
| Feature | Status | Notes |
|---|---|---|
| tokens.dart (AppColors, AppSpace, AppRadius, AppText) | ✅ Verified complete | All Material 3, Cairo/Tajawal font |
| app_theme.dart (ThemeData light/dark) | ✅ Verified complete | Used in main.dart |
| strings.dart (L — Arabic/English) | ✅ Verified complete | 60+ keys, RTL support |

## CI / Build
| Feature | Status | Notes |
|---|---|---|
| build.yml (APK) | 🔄 Implemented, not yet verified | Flutter 3.47.7, analyze, test, APK |
| dart.yml (CI checks) | 🔄 Implemented, not yet verified | Static analysis only |
| ProGuard rules | ✅ Verified complete | Gson + flutter_local_notifications |
| AndroidManifest (permissions + boot receiver) | ✅ Verified complete | Injected by workflow |

## Out of Scope (Frozen)
- Google sign-in — stub only, not implemented
- Cloud backup — localStorage only
- Live Gemini integration tests — tagged `live`, skipped in CI
