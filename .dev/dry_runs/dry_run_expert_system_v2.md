# Dry Run: Granular Expert System v2

Updated: 2026-01-28 (after experts-refactor branch)

**Purpose:** Validate the new expert selection flow with individual expert files and multi-expert default.

---

## System State

### Expert Files (11 total)
```
system/experts/
├── _index.md                    (~792 tokens)
├── systems-architect.md         (~668 tokens)
├── staff-engineering-lead.md    (~659 tokens)
├── implementation-engineer.md   (~844 tokens)
├── implementation-auditor.md    (~824 tokens)
├── tech-debt-analyst.md         (~947 tokens)
├── qa-engineer.md               (~852 tokens)
├── test-automation-architect.md (~1,006 tokens)
├── integration-specialist.md    (~1,136 tokens)
├── security-architect.md        (~1,274 tokens)
├── sre.md                       (~1,286 tokens)
└── build-engineer.md            (~1,641 tokens)
```

### New Selection Flow (per AGENTS.md)
```
1. Scan expert filenames in system/experts/ (~20 tokens)
2. Read headers (first 3 lines) of likely matches for Triggers:
3. Load 2-3 experts by default - real work spans domains
4. Reduce to 1 only if task is truly single-domain (rare)
```

---

## Test Prompts

### Prompt 1: "Add user authentication with JWT"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request → work.md |
| 3 | Mode | Full (new feature, behavior change) |
| 4 | Expert selection begins | |
| 4a | Scan filenames | See: systems-architect, implementation-engineer, security-architect, etc. |
| 4b | Keywords in prompt | "authentication", "JWT" |
| 4c | Match to triggers | |
| | - security-architect.md | **Triggers:** security, auth, authentication ✅ |
| | - implementation-engineer.md | **Triggers:** implementation, coding ✅ |
| | - systems-architect.md | **Triggers:** architecture, API design ✅ |
| 4d | Select 2-3 (default) | security-architect + implementation-engineer + systems-architect |
| 5 | Load experts | ~2,800 tokens |
| 6 | Execute | Design auth flow, implement, add tests |

**Total context:** AGENTS.md (1,423) + _index.md (792) + 3 experts (~2,800) = **~5,015 tokens**

**Verdict:** ✅ Correct. Multi-expert selection works. All three contribute:
- systems-architect → overall auth architecture
- security-architect → security requirements, threat model
- implementation-engineer → actual code patterns

---

### Prompt 2: "Fix the bug where login fails on Safari"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request → work.md |
| 3 | Mode | Full (bug fix) |
| 4 | Expert selection | |
| 4a | Scan filenames | See all 11 experts |
| 4b | Keywords | "fix", "bug", "login", "Safari" (browser-specific) |
| 4c | Match triggers | |
| | - implementation-engineer.md | **Triggers:** implementation, coding ✅ |
| | - qa-engineer.md | **Triggers:** test, QA, edge cases ✅ |
| | - security-architect.md | login = auth context? Maybe. |
| 4d | Select 2 (bug fix typical) | implementation-engineer + qa-engineer |
| 5 | Load experts | ~1,700 tokens |
| 6 | Execute | Find bug, fix, add test for Safari case |

**Total context:** ~3,900 tokens

**Verdict:** ✅ Correct. Bug fix = implement + verify pattern.

---

### Prompt 3: "Review this PR for security issues"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request (audit) → audit.md? |
| 3 | Mode | Full |
| 4 | Expert selection | |
| 4a | Scan filenames | |
| 4b | Keywords | "review", "PR", "security" |
| 4c | Match triggers | |
| | - security-architect.md | **Triggers:** security ✅ |
| | - implementation-auditor.md | **Triggers:** code review, audit ✅ |
| 4d | Select 2 | security-architect + implementation-auditor |
| 5 | Load | ~2,100 tokens |
| 6 | Execute | Security audit + compliance check |

**Total context:** ~4,300 tokens

**Verdict:** ✅ Correct. Security review = security + audit.

---

### Prompt 4: "Refactor the data layer to use Repository pattern"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request → work.md |
| 3 | Mode | Full (refactor) |
| 4 | Expert selection | |
| 4a | Scan filenames | |
| 4b | Keywords | "refactor", "data layer", "Repository pattern" |
| 4c | Match triggers | |
| | - staff-engineering-lead.md | **Triggers:** tech debt, complexity ✅ |
| | - tech-debt-analyst.md | **Triggers:** refactoring, cleanup ✅ |
| | - implementation-engineer.md | **Triggers:** design patterns ✅ |
| | - systems-architect.md | **Triggers:** architecture ✅ |
| 4d | Select 3 | staff-engineering-lead + tech-debt-analyst + implementation-engineer |
| 5 | Load | ~2,450 tokens |
| 6 | Execute | Assess impact, plan migration, implement |

**Total context:** ~4,700 tokens

**Verdict:** ✅ Correct. Refactor = assess + plan + execute. Per _index.md: "Refactor → staff-engineering-lead + tech-debt-analyst + implementation-engineer"

---

### Prompt 5: "Set up CI/CD pipeline with Docker"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request → work.md |
| 3 | Mode | Full |
| 4 | Expert selection | |
| 4a | Scan filenames | See: sre.md, build-engineer.md |
| 4b | Keywords | "CI/CD", "pipeline", "Docker" |
| 4c | Match triggers | |
| | - build-engineer.md | **Triggers:** CI/CD, pipeline, docker ✅ |
| | - sre.md | **Triggers:** reliability, deploy ✅ |
| 4d | Select 2 | build-engineer + sre |
| 5 | Load | ~2,900 tokens |
| 6 | Execute | Configure pipeline, Dockerfile, deployment |

**Total context:** ~5,100 tokens

**Verdict:** ✅ Correct. Per _index.md: "Deployment → sre + build-engineer"

---

### Prompt 6: "What's the best way to structure my API?"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | **Question only** → Answer directly |
| 3 | Mode | N/A (no code changes) |
| 4 | Expert selection | |
| 4a | Question about architecture | |
| 4b | Keywords | "structure", "API" |
| 4c | Decision | Load expert? This is discussion, not implementation |
| 4d | Select 1 (pure discussion) | systems-architect |
| 5 | Load | ~668 tokens |
| 6 | Execute | Provide API design guidance |

**Total context:** ~2,900 tokens

**Verdict:** ✅ Correct. Pure architecture discussion = single expert is appropriate.

---

### Prompt 7: "Increase test coverage for the user module"

**Step-by-step trace:**

| Step | Action | Result |
|------|--------|--------|
| 1 | Read AGENTS.md | ✓ |
| 2 | Routing | Work request → work.md |
| 3 | Mode | Full |
| 4 | Expert selection | |
| 4a | Scan filenames | |
| 4b | Keywords | "test", "coverage" |
| 4c | Match triggers | |
| | - qa-engineer.md | **Triggers:** test, coverage ✅ |
| | - test-automation-architect.md | **Triggers:** test automation, test framework ✅ |
| 4d | Select 2 | qa-engineer + test-automation-architect |
| 5 | Load | ~1,850 tokens |
| 6 | Execute | Identify gaps, write tests |

**Total context:** ~4,000 tokens

**Verdict:** ✅ Correct. Per _index.md: "Test coverage → qa-engineer + test-automation-architect"

---

## Summary

| Prompt | Experts Selected | Tokens | Correct? |
|--------|-----------------|--------|----------|
| JWT auth | 3 (sec + impl + arch) | ~5,015 | ✅ |
| Safari bug fix | 2 (impl + qa) | ~3,900 | ✅ |
| Security PR review | 2 (sec + auditor) | ~4,300 | ✅ |
| Repository refactor | 3 (lead + debt + impl) | ~4,700 | ✅ |
| CI/CD setup | 2 (build + sre) | ~5,100 | ✅ |
| API structure question | 1 (arch) | ~2,900 | ✅ |
| Test coverage | 2 (qa + automation) | ~4,000 | ✅ |

**Average experts per task:** 2.1
**Average context loaded:** ~4,300 tokens

---

## Findings

### ✅ Working Well

1. **Multi-expert default is correct** - Most prompts naturally needed 2-3 experts
2. **Filename scanning works** - Easy to identify relevant experts from names alone
3. **Triggers in headers enable quick matching** - Don't need to read full file
4. **_index.md Quick Reference table is accurate** - Suggestions match actual selection
5. **Single expert for pure discussion is appropriate** - System correctly reduces when warranted

### ⚠️ Edge Cases to Watch

1. **Ambiguous prompts** - "Improve performance" could be SRE (monitoring) or Systems Architect (design) or Implementation Engineer (code optimization). May need to load 3.

2. **Cross-cutting concerns** - Security touches everything. May over-select security-architect if "security" is mentioned even tangentially.

3. **"Fix" vs "Refactor"** - Both involve code changes but have different expert profiles:
   - Fix: implementation-engineer + qa-engineer
   - Refactor: staff-engineering-lead + tech-debt-analyst + implementation-engineer

### 💡 Potential Improvements

1. **Add "Related" field to expert headers** - e.g., `Related: implementation-engineer` in qa-engineer.md to suggest common pairings

2. **Priority tiers for trigger keywords** - "auth" in security-architect should be higher priority than "auth" potentially matching elsewhere

---

## Conclusion

**The new granular expert system works correctly.**

- Multi-expert default (2-3) matches real task complexity
- Individual files allow extensive documentation per expert
- Drop-in/remove experts is now trivial
- Token cost is well-controlled (~4,300 avg vs 22,400 if loading everything)
