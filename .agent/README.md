# .agent/ index
| File | Purpose | Update when |
|---|---|---|
| HANDOFF.md | 20-line cold start: what to test/trust/avoid | every session end |
| IMPLEMENTATION_STATE.md | dated session log: verified / not verified / next | every green build |
| implementation.md | feature inventory, one honest status each + verification log | status changes |
| CHANGELOG.md | completed work only | each merged change |
| LESSONS.md | symptom -> cause -> action -> guard | each red build / surprise |
| DECISIONS.md | decided / open (owner) items | when decided |
| archive/ | superseded docs with ARCHIVED banner | when superseding |
Non-negotiables: no secrets anywhere; no "verified" without evidence; never push/merge main before owner device test.
