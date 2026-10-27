# LESSONS

## L1. Red CI hid behind "infos" noise (2026-10-27)
Symptom: analyze printed 134 issues, looked hopeless. Cause (proved: log + failing step): only 3 were WARNINGS; infos are not fatal with --no-fatal-infos. Action: filter the log by severity first (clean_log.py hides infos). Guard: workflow comment states warnings fatal / infos not.

## L2. Docs claimed verification that never happened (2026-10-27)
Symptom: HANDOFF said "47 tests", implementation.md "Verified complete"; reality: no test/ dir, CI never green. Cause: docs copied from another repo/agent. Action: verify headline claim with one API call at start. Guard: statuses need a Verification log row (build, commit, CI, device).

## L3. Workflow copied between projects (2026-10-27)
Symptom: build.yml injected boot receivers/ProGuard for a plugin not in pubspec, project-name manager_assistant. Cause: copy-paste. Action: workflow contains only what this app's pubspec needs.
