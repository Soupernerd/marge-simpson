# AGENTS.md — Assistant Operating Rules

**Priority:** correctness > safety > minimal diffs > speed

**Scope:** The `marge_simpson/` folder is tooling, not target. Never create marge_simpson files outside this folder.

---

## Core Rules

1. **Read first** — Open files before making claims
2. **Search before implementing** — Don't assume functionality is missing
3. **Root cause fixes** — No band-aids
4. **Minimal changes** — Fewest files/lines necessary
5. **Capture the why** — Document WHY fixes work, not just what changed
6. **No secrets in code** — Use env vars

**Major changes** (architecture, schema, API contracts) → Stop, get approval with plan + risks.

---

## Tracking

| File | Purpose |
|------|---------|
| `assessment.md` | Findings + root cause + verification evidence |
| `tasklist.md` | Work queue: backlog → in-progress → done |
| `instructions_log.md` | Standing user instructions |
| `plans/[name]_MS-XXXX.md` | Feature plans (created for each feature) |
```
IMPLEMENT → VERIFY → RECORD → COMPLETE
```

```bash
# Windows
./marge_simpson/scripts/verify.ps1 fast -SkipIfNoTests

# macOS/Linux
./marge_simpson/scripts/verify.sh fast --skip-if-no-tests
```

**Never claim "tests passed" without raw output or log path.**

---

## Routing

| Intent | Action |
|--------|--------|
| Question | Answer directly |
| Work (fix, add, change) | Read `workflows/work.md`, create MS-#### |
| Audit | Read `workflows/audit.md` first |
| Planning mode (`PLANNING ONLY`, `plan only`) | Read `workflows/planning.md` — NO code changes |
| Loop mode (`loop until clean`) | Read `workflows/loop.md` |

**Mixed intent** (e.g., question + feature + bug): Answer questions inline (no ID), then process each work item per `work.md` (each gets MS-####).

---

## Response Format

When delivering work, output:
- IDs touched
- Files modified
- Verification evidence (raw output)

See `workflows/work.md` for full format.

---

## Token Estimate (REQUIRED)

End every response with:

`📊 ~In: X,XXX | Out: X,XXX | Est: $X.XXXX`

Pricing in `marge_simpson/model_pricing.json`.

---

## Resources

Read only when needed:
- `workflows/_index.md` → find the right workflow
- `experts/_index.md` → domain expertise (if exists)
- `knowledge/_index.md` → preferences, decisions, patterns
