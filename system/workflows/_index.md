# Workflows Index

> Route to the right workflow based on intent. Read only what you need.
> **Primary routing is in AGENTS.md** — this file is reference only.

## Path Resolution

All paths in this folder are relative to the project root:
- `marge-simpson/system/tracking/` → tracking files
- `marge-simpson/system/workflows/` → workflow files  
- `marge-simpson/system/experts/` → domain expertise
- `marge-simpson/system/knowledge/` → decisions and patterns

## Quick Reference

| Intent | Signal | Workflow File | Creates ID? |
|--------|--------|---------------|-------------|
| **Session Start** | New conversation, first message | [session_start.md](session_start.md) | No |
| **Question** | Curiosity, "how", "why", "what" | None (answer directly) | No |
| **Work** | Fix, add, change, build | [work.md](work.md) | Yes (or continue existing) |
| **Document** | Generate docs, README, API docs | [work.md](work.md) (docs are work) | Yes |
| **Audit** | "audit", "review codebase" | [audit.md](audit.md) → then work.md (only if requested) | Yes (generates multiple) |
| **Review** | Code review, analysis | [audit.md](audit.md) (analysis mode) | Optional |
| **Loop** | "loop until clean", "iterate" | [loop.md](loop.md) (modifier) | Continues existing |
| **Planning** | "PLANNING ONLY", design discussion | [planning.md](planning.md) | Yes (plan ID) |
| **Decision** | Capture decisions, wrap up | [session_end.md](session_end.md) | No |
| **Session End** | Task complete, goodbye, natural end | [session_end.md](session_end.md) | No |

## Decision Tree

```
User message received
    │
    ├─ Just asking a question? → Answer directly, no ID needed
    │
    ├─ Planning/design discussion? (new feature planning)
    │   └─ Read marge-simpson/system/workflows/planning.md
    │   └─ Creates MS-#### plan, uses feature_plan_template.md if multi-step
    │
    ├─ Wants something done (fix/add/change/docs)?
    │   ├─ Read marge-simpson/system/workflows/work.md
    │   └─ If "loop until clean" → Also read marge-simpson/system/workflows/loop.md
    │
    ├─ Wants codebase audit/review?
    │   └─ Read marge-simpson/system/workflows/audit.md (discovery)
    │   └─ Use tracking location from active AGENTS.md (meta vs base)
    │   └─ If meta run, apply changes to marge-simpson/ (not .meta_marge/)
    │   └─ Then marge-simpson/system/workflows/work.md (execution)
    │
    ├─ Capture decisions / wrap up?
    │   └─ Read marge-simpson/system/workflows/session_end.md
    │
    └─ Task complete / session ending?
        └─ Read marge-simpson/system/workflows/session_end.md
```

## Token Costs

| Scenario | Files to Read | Tokens |
|----------|---------------|--------|
| Question only | AGENTS.md only | ~1,500 |
| Single work item | AGENTS.md + work.md | ~2,500 |
| Work + loop | AGENTS.md + work.md + loop.md | ~3,300 |
| Audit | AGENTS.md + audit.md + work.md | ~3,000 |
| Planning only | AGENTS.md + planning.md | ~2,100 |
| Session end | session_end.md | ~500 |
