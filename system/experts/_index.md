# Expert System

> Dynamic expert discovery and loading.

## How It Works

1. Scan `system/experts/*.md` (excluding this file)
2. Each expert declares triggers in its header
3. Match current task keywords → load matching expert(s)
4. Multiple experts can load for complex tasks

---

## Discovery Instructions

When determining which expert(s) to load:

1. **Read the expert file headers** - each has a `Triggers:` line
2. **Match keywords** from the current task to trigger words
3. **Load matching experts** - can load multiple if task spans domains
4. **Priority** - if multiple experts match, higher priority loads first

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

## Quick Reference by Task

| Task | Experts to Load |
|------|-----------------|
| New feature | systems-architect + implementation-engineer |
| Bug fix | implementation-engineer + qa-engineer |
| Security review | security-architect |
| Test coverage | qa-engineer + test-automation-architect |
| Deployment | sre + build-engineer |
| Performance | sre + systems-architect |
| Refactor | staff-engineering-lead + tech-debt-analyst |
| Code review | implementation-auditor |
