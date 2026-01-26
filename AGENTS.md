# AGENTS.md — Assistant Operating Rules

**Priority:** correctness > safety > minimal diffs > speed

## Scope (Critical) (Hard)
**Scope:** This folder is tooling, not the target. Audit the workspace/repo OUTSIDE this folder. Track findings in `./system/tracking/`. Never create files from this folder outside it. Brings in experts

---

## Task Complexity (Critical) (Hard)

| Task | Mode |
|------|------|
| Typo, rename, comment, format, spelling | **Lite** → Read, fix, list files. No ID tracking. |
| Feature, refactor, audit, multi-file, architecture | **Full** → Follow workflows below. |

---

## Core Rules (Critical) (Hard)

1. **Read first** — Open files before claiming
2. **Search before implementing** — Don't assume missing
3. **Root cause fixes** — No band-aids
4. **Minimal changes** — Fewest files/lines
5. **Capture why** — Document reasoning
6. **No secrets** — Use env vars
7. **State uncertainty** — What you checked, know, don't know

**Major changes** → Stop, get approval with plan + risks.

---

## Expert Subagents (Critical) (Hard)

**MANDATORY:** Every task requires expert subagent(s). No exceptions.

| Task Type | Required Experts | Reference |
|-----------|------------------|----------|
| Security/audit | Security experts (2-3) | `security.md` |
| Architecture | Systems + Implementation | `architecture.md` |
| Code changes | Implementation + Testing | `implementation.md`, `testing.md` |
| Frontend/UI | Design + Implementation | `design.md` |
| Deployment | DevOps + Documentation | `devops.md` |
| Research | Domain experts (2+) | See `./system/experts/_index.md` |

**Rules:**
- Use **multiple experts** for complex tasks (audits, architecture, multi-file)
- Use **parallel subagents** when tasks are independent
- Direct tools only for: reading files, running commands, simple single-line fixes
- When in doubt: **more experts, not fewer**

---

## Tracking (Critical) (Hard)

| File | Purpose |
|------|---------|
| `./system/tracking/assessment.md` | Findings + evidence |
| `./system/tracking/tasklist.md` | Work queue |

```
IMPLEMENT → VERIFY → RECORD → COMPLETE
```

Verify: `./system/scripts/verify.ps1 fast` (Win) or `./system/scripts/verify.sh fast` (Unix)

**Never claim "passed" without raw output.**

---

## Routing (Critical) (Hard)

| Intent | Action |
|--------|--------|
| Question | Answer directly |
| Work | Read `./system/workflows/work.md`, create MS-#### |
| Audit | Read `./system/workflows/audit.md` |
| Planning | Read `./system/workflows/planning.md` — NO code |
| Loop | Read `./system/workflows/loop.md` |

Mixed intent: Answer questions inline, then process work items (each gets MS-####).

---

## Response Format

Output: IDs touched, files modified, verification evidence, knowledge captured.
Full format: `./system/workflows/work.md`

---

## Token Estimate (Critical) (Hard)

End every response: `📊 ~In: X,XXX | Out: X,XXX | Est: $X.XXXX`

---

## Resources (Critical) (Hard)

| Need | Load |
|------|------|
| Decisions | `./system/knowledge/_index.md` |
| Experts | `./system/experts/_index.md` |
| Workflows | `./system/workflows/_index.md` |
