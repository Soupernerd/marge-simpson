# Expert System

> Dynamic expert discovery and loading.

## How It Works

1. Scan `system/experts/*.md` (excluding this file)
2. Each expert declares triggers in its header
3. Match current task keywords → load matching expert(s)
4. **Default: expect 2-3 experts per task** - real work spans domains

---

## Discovery Instructions

When determining which expert(s) to load:

1. **Scan expert filenames first** - ~20 tokens to see all options
2. **Read headers of likely matches** - `Triggers:` line is first 3 lines
3. **Select 2-3 experts by default** - most tasks span domains (e.g., implementation + testing)
4. **Reduce to 1 only if task is truly single-domain** (rare)

**Priority**: If >3 experts match, prefer higher priority (1 = highest)

---

## Expert File Format

Each expert file follows this structure:

```markdown
# Expert Name

**Triggers:** keyword1, keyword2, keyword3
**Category:** engineering | quality | security | operations
**Priority:** 1-5 (1 = highest)

---

[Expert content]
```

---

## Available Experts

### Engineering
- [systems-architect.md](systems-architect.md) - Architecture, distributed systems, API design
- [staff-engineering-lead.md](staff-engineering-lead.md) - Tech debt, complexity, developer experience
- [implementation-engineer.md](implementation-engineer.md) - Design patterns, frameworks, production code
- [implementation-auditor.md](implementation-auditor.md) - Code review, spec compliance, drift detection
- [tech-debt-analyst.md](tech-debt-analyst.md) - Debt identification, refactoring strategy

### Quality
- [qa-engineer.md](qa-engineer.md) - Test strategy, edge cases, coverage
- [test-automation-architect.md](test-automation-architect.md) - Test frameworks, CI integration, mocking
- [integration-specialist.md](integration-specialist.md) - Integration testing, quality gates

### Security
- [security-architect.md](security-architect.md) - Security design, compliance, threat modeling

### Operations
- [sre.md](sre.md) - Reliability, observability, incident response
- [build-engineer.md](build-engineer.md) - Build systems, dependencies, artifacts

---

## Common Expert Combinations

Most real tasks need 2-3 experts. Here are typical patterns:

| Task | Experts | Why |
|------|---------|-----|
| New feature | systems-architect + implementation-engineer + qa-engineer | Design → Build → Test |
| Bug fix | implementation-engineer + qa-engineer | Fix → Verify |
| Refactor | staff-engineering-lead + tech-debt-analyst + implementation-engineer | Assess → Plan → Execute |
| Security review | security-architect + implementation-auditor | Threat model → Verify code |
| Test coverage | qa-engineer + test-automation-architect | Strategy → Implementation |
| Deployment | sre + build-engineer | Reliability → Pipeline |
| Performance | sre + systems-architect | Measure → Optimize |
| Code review | implementation-auditor + qa-engineer | Spec compliance → Test coverage |

**Single expert is rare** - usually only for:
- Pure architecture discussion (no implementation)
- Pure test strategy (no automation)
- Isolated security assessment
| Code review | implementation-auditor |
