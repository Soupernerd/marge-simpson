# Temporary Assessment: Docs vs System Reality

> Expert audit comparing documentation claims vs actual system behavior.
> **Goal:** Identify what's accurate, what's aspirational, and what's conflicting.

---

## Executive Summary

**Marge's Intended Purpose (per README):**
> "A persistent knowledge base that keeps AI assistants informed across sessions."

**What It Actually Is (per system files):**
1. A **context injection system** - AGENTS.md + workflows loaded into AI
2. A **work tracking system** - MS-#### IDs, assessment.md, tasklist.md
3. A **CLI wrapper** - Convenience scripts for running claude/aider with context
4. A **meta-development framework** - .meta_marge for self-improvement

---

## Strength Comparison

### README.md Strengths
| Claim | Accurate? | Notes |
|-------|-----------|-------|
| "Five ways to use Marge" | ✅ Yes | Chat, CLI Local, CLI Global, Lite, Meta - all work |
| "Tracks work with IDs" | ✅ Yes | MS-#### system in assessment/tasklist |
| "Runs tests automatically" | ⚠️ Partial | Only if verify.config.json configured |
| "Auto-detects project type" | ✅ Yes | Node, Python, Go, Rust, Ruby detection |
| "Loop mode" | ✅ Yes | `--loop` and prompt "loop until clean" both work |
| "Works with VS Code Copilot, Claude, Cursor" | ✅ Yes | Context-agnostic prompts |

### README.md Weaknesses
| Claim | Issue |
|-------|-------|
| "Persistent knowledge base" | **Overstated** - Only persists IF user/AI writes to knowledge/*.md files. No automatic persistence. More accurately: "a structured context system" |
| "Each session starts informed" | **Conditional** - Only if AI reads AGENTS.md and tracking files. No magic - requires prompts that instruct reading |
| Chat prompts reference "marge-simpson folder" | **Brittle** - If user renames folder, prompts break |

### AGENTS.md Strengths
| Feature | Accurate? | Notes |
|---------|-----------|-------|
| Mode declaration (Lite/Full) | ✅ Yes | Clear, enforced in workflows |
| Expert loading requirement | ✅ Yes | work.md enforces this |
| MS-#### tracking | ✅ Yes | Works well |
| Verification requirement | ✅ Yes | verify.ps1/sh work |
| Token estimate footer | ⚠️ Aspirational | Relies on AI compliance |

### AGENTS.md Weaknesses
| Rule | Issue |
|------|-------|
| "NEVER claim verification passed without raw output" | **Unenforceable** - AI can still claim it |
| "NEVER skip expert load in Full mode" | **Unenforceable** - Depends on AI compliance |
| Token estimate | **Often ignored** - AI frequently omits this |

### Expert Files Strengths
| File | Quality | Notes |
|------|---------|-------|
| engineering.md | ✅ Good | Clear roles, boundaries, experience levels |
| quality.md | ✅ Good | Practical testing focus |
| security.md | ✅ Good | Concise, useful |
| operations.md | ✅ Good | Practical DevOps/SRE focus |

### Expert Files Weaknesses
| Issue | Impact |
|-------|--------|
| **Not actually loaded** | High - AI has to explicitly read these files. No automatic injection |
| **Generic advice** | Medium - Same advice for every project |
| **No project context** | Medium - Experts don't know YOUR codebase |

### Workflow Files Strengths
| File | Quality | Notes |
|------|---------|-------|
| work.md | ✅ Good | Clear steps, mode checks, verification |
| audit.md | ✅ Good | Structured discovery process |
| loop.md | ✅ Good | Min/max iteration control |
| _index.md | ✅ Good | Decision tree for routing |

### Knowledge System
| Reality | Impact |
|---------|--------|
| **Empty by default** | High - No built-in knowledge |
| **Manual entry required** | High - AI or user must write entries |
| **No decay implemented** | Low - decay.ps1/sh exist but never run |
| **Tag system unused** | Medium - Grep approach works but tags empty |

---

## Misalignments Found

### 1. "Persistent Knowledge Base" vs Reality
**README claims:** "keeps AI assistants informed across sessions"
**Reality:** Only if:
- AI reads tracking files (requires prompt instruction)
- Someone wrote to knowledge/*.md (usually empty)
- User starts with the right prompt template

**Recommendation:** Change tagline to "structured AI context system" or "session-aware AI assistant framework"

### 2. "Expert Subagents" vs Reality
**AGENTS.md claims:** "Full mode requires experts. No exceptions."
**Reality:**
- Experts are markdown files that AI must manually read
- No enforcement mechanism
- AI can proceed without loading them

**Recommendation:** Either enforce in prompts or soften the claim

### 3. Automatic vs Manual
**README implies:** Automation ("auto-detects", "runs tests automatically")
**Reality:**
- Project detection: ✅ Automatic
- Test running: ⚠️ Semi-automatic (requires trigger)
- Knowledge capture: ❌ Manual
- Expert loading: ❌ Manual

**Recommendation:** Clarify what's automatic vs requires prompting

### 4. Token Estimate Compliance
**AGENTS.md requires:** Token estimate in every response
**Reality:** AIs frequently omit this, no enforcement possible

**Recommendation:** Make it optional or remove requirement

---

## What's Working Well

1. **CLI scripts** - Well-tested, cross-platform, feature-complete
2. **Tracking system** - MS-#### IDs, assessment/tasklist work well
3. **Verification flow** - verify.ps1/sh with config.json is solid
4. **Mode system** - Lite/Full distinction is practical
5. **Meta-development** - convert-to-meta flow works cleanly
6. **Prompt templates** - README templates are copy-paste ready

---

## What Needs Work

| Priority | Item | Issue |
|----------|------|-------|
| P0 | README tagline | Overpromises "persistent knowledge" |
| P1 | Knowledge system | Empty/unused by default |
| P1 | Expert enforcement | Claimed but not enforced |
| P2 | Token estimate | Remove or make optional |
| P2 | Decay scripts | Exist but never invoked |

---

## Actual Value Proposition (Honest Version)

**What Marge IS:**
1. A **starter kit** for giving AI structured context
2. A **work tracking template** (MS-#### system)
3. A **CLI convenience layer** for AI coding tools
4. A **self-improvement framework** (meta-development)

**What Marge IS NOT:**
1. Not a "knowledge base" (nothing persists automatically)
2. Not "self-aware" (AI must be told to read files)
3. Not enforcing rules (AI compliance is voluntary)

---

## Recommended Positioning

**Current (README):**
> "A persistent knowledge base that keeps AI assistants informed across sessions."

**Proposed:**
> "A structured context system for AI coding assistants. Drop-in AGENTS.md rules, work tracking templates, and CLI tools that give your AI session continuity and accountability."

This is accurate, concrete, and doesn't overpromise.

---

## Files Analyzed

- README.md (417 lines)
- AGENTS.md (133 lines)
- AGENTS-lite.md (78 lines)
- system/experts/*.md (4 files, ~1,450 tokens)
- system/workflows/*.md (7 files)
- system/knowledge/*.md (6 files, mostly empty)
- .dev/README.md (190 lines)
- CHANGELOG.md (268 lines)

**Experts consulted:** Engineering (architecture, implementation), Quality (testing), Security, Operations (DevOps)

---

*Assessment created: 2026-01-26*
*This is a temporary file for review - delete after decisions made*
