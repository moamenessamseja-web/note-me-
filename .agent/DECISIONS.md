# DECISIONS
## Decided (2026-10-27)
- Native Flutter only; no WebView. Own Markdown renderer over `markdown` package (no flutter_markdown: discontinued upstream, version unverifiable offline).
- Application id prefix app.noteme (flutter create --org app.noteme). Nothing published, so reversible; owner may change before any store release.
## Open (owner)
- Final application id + fixed upload keystore (before Play Store).
- Merge recovery/flutter-repair into main (after device test).
- Bundle Tajawal/Cairo font (needs source + licence confirmation).
