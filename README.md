# Mindbook Pro — Markdown Notes (web re-creation)

A faithful, fully functional re-creation of **Mindbook Pro: Markdown Notes** by MetaFrame,
built as a local-first React + TypeScript web app. No backend, no network calls — every note
lives in `localStorage`, encrypted notes in the vault use AES-GCM.

The UI is reconstructed from the 8 Play Store screenshots of the original app (login,
notebook, editor, themes, vault, backup, categories, search) using
[rea](https://github.com/morluto/rea) as the reverse-engineering workflow for extracting
layout, spacing, colour, and copy evidence.

## Quick start

```bash
npm install
npm run dev        # http://localhost:5173
npm run build      # production bundle in dist/
npm run preview    # serve the built bundle
npm test           # 47 tests (vitest + jsdom)
npm run typecheck  # tsc --noEmit
```

## What it does

| Area | Behaviour |
| --- | --- |
| Auth | Local account register/login, guest mode, simulated Google sign-in, session persistence |
| Notebook | Note list with category chips, live search, sort modes, pin, delete-with-confirm |
| Editor | Markdown editor, formatting toolbar, autosave on leave, draft resume |
| Reader | Rendered markdown (marked + DOMPurify sanitised), font size control |
| Themes | 336 palettes (56 colours × 6 shades), light/dark/system, live CSS-variable theming |
| Vault | AES-GCM encrypted notes, password unlock, wrong password rejection |
| Backup | Create/restore/import/export JSON backups, target picker, backup history |
| Categories | Full CRUD with colour + icon pickers, per-category note counts |
| i18n | 12 languages, RTL flip for Arabic, per-locale number/date formatting |
| Settings | Theme, mode, font size/family, language, auto-backup, storage stats, reset |

## Architecture

```
src/
  App.tsx                  navigation stack + screen switch
  store/AppContext.tsx     single source of truth (notes, categories, settings, auth, vault)
  lib/
    storage.ts             namespaced localStorage access (mindbook.pro.v1.*)
    crypto.ts              AES-GCM via WebCrypto, SHA-256 fallback engine
    themes.ts              336 palettes + CSS variable generation
    color.ts               hex/HSL/RGB conversion, luminance, mix, alpha, shift
    markdown.ts            marked + DOMPurify render, stats, preview, tag extraction
    i18n.ts                12 complete dictionaries + RTL helper
    seed.ts                first-run demo notes and categories
  components/              Icon, NoteCard, Drawer, shared UI kit
  screens/                 11 screens (auth, home, editor, reader, search, …)
```

State flows one way: screens call `useApp()` actions, the provider persists to
`localStorage` on every mutation, and the whole tree re-renders from the new state.
Theme changes write CSS custom properties on `document.documentElement`, so a palette
swap repaints instantly without remounting.

## Design fidelity notes

* Colour palette mirrors the original's blue primary (`#0B6BF5`) with per-category accent tints.
* Cards use tinted backgrounds per category rather than plain white, matching the original screenshots.
* Typography: system stack, 16px default body, tight heading tracking, 1.55 line height.
* Dark mode swaps surface/text tokens, not just inverting — backgrounds stay near-black `#0d1117`.

## Tests

`npm test` runs 47 tests across two files:

* `src/test/lib.test.ts` — 21 unit tests: markdown rendering + XSS stripping, theme resolution,
  colour math round-trips, i18n completeness for all 12 languages, AES-GCM round-trip and
  wrong-password rejection.
* `src/test/app.test.tsx` — 26 integration tests: auth validation and registration, note CRUD,
  search/filter/pin/sort, autosave, reader mode, theme + dark mode persistence, Arabic RTL flip,
  vault unlock/reject, backup creation, category creation, logout.

## Known gaps

* Backend/sync is out of scope by design — the app is deliberately local-only.
* Google sign-in is a local stub (no OAuth); it creates a fixed local profile.
* Backup "cloud" target writes to `localStorage`, not real cloud storage.
* The Play Store screenshots covered phone portrait layout only; tablet/desktop is responsive but unreferenced.

## Credits

Original app: **Mindbook Pro: Markdown Notes** © MetaFrame.
This is an independent educational re-creation; no original assets or code are included.
