# Multi-Agent Deliberation: System Architecture

**Status:** Core System Design  
**Version:** 1.0.0  
**Created:** 2026-01-28  

---

## This Is THE System

Multi-Agent Deliberation is not a feature to be enabled. It is not a fallback for edge cases. It is not an optimization layer that triggers under specific conditions.

**It is the execution model itself.**

Every task—without exception—flows through the coordination pipeline. The depth of coordination scales automatically based on task characteristics. The user experience is unchanged: submit prompt, receive result. The sophistication is invisible.

```
┌─────────────────────────────────────────────────────────────────────────┐
│  THE EXECUTION MODEL                                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  User Prompt                                                            │
│       │                                                                 │
│       ▼                                                                 │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌────────┐│
│  │ INTAKE  │───▶│  ROUTE  │───▶│COORDINATE───▶│ EXECUTE │───▶│ REVIEW ││
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘    └────────┘│
│                                     │                                   │
│                                     │                                   │
│                      ┌──────────────┼──────────────┐                   │
│                      ▼              ▼              ▼                   │
│                  INSTANT        STANDARD      EXTENDED                 │
│                  ~0 tokens      ~200 tokens   ~500 tokens              │
│                                                                         │
│       │                                                                 │
│       ▼                                                                 │
│  Result to User                                                         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

There is no bypass. The "fast path" goes THROUGH the system, not around it.
```

---

## Design Principles

### 1. Invisible Orchestration

The user submits a prompt. The user receives a result. Everything in between is the system's responsibility.

- No expert selection by user
- No deliberation invocation
- No coordination depth configuration
- No visibility into process (unless explicitly requested)

**The interface is identical regardless of task complexity.**

### 2. Continuous Depth Scaling

Coordination is not binary (on/off). It's a spectrum:

| Depth | When | Token Cost | What Happens |
|-------|------|------------|--------------|
| **Instant** | Single expert, high confidence | ~0 | Route directly to expert |
| **Quick** | 1-2 experts, clear ownership | ~50 | Brief claim, execute |
| **Standard** | 2-3 experts, distinct domains | ~150-200 | Coordinate ownership, execute |
| **Extended** | 3+ experts, overlapping/ambiguous | ~400-600 | Full deliberation, then execute |

The system determines depth. Not the user. Not the task author.

### 3. Always-On Review

Review is not optional. It's part of the pipeline.

- Instant routing → minimal sanity check
- Standard coordination → domain-appropriate review
- Extended deliberation → comprehensive multi-expert review

The depth of review scales with the depth of coordination.

### 4. Specialization Over Generalization

Every task is handled by specialists—even simple ones. A "fix typo" task routes to the Implementation Engineer, not a generic handler. The expert may do almost nothing (accept and execute), but the routing exists.

This means:
- Consistent expert boundaries
- Predictable behavior
- No "general mode" to maintain

---

## The Coordination Pipeline

### Stage 1: INTAKE

Parse the incoming task. Extract:
- Explicit keywords (triggers)
- Mentioned files/code
- Prior conversation context
- User preferences (if known)

**Output:** Structured task object

### Stage 2: ROUTE

Match task against expert registry. Compute relevance scores.

```
FOR each expert IN registry:
    score = computeRelevance(expert, task)
    IF score > threshold:
        candidates.add(expert)
```

**Output:** Candidate list with relevance scores

### Stage 3: COORDINATE

Determine depth. Execute appropriate coordination protocol.

```
depth = determineDepth(candidates)

SWITCH depth:
    INSTANT:
        lead = candidates[0]  // highest confidence
        
    QUICK:
        lead = getClaim(candidates[0])
        
    STANDARD:
        claims = getClaims(candidates)
        assignments = resolveOwnership(claims)
        
    EXTENDED:
        claims = getClaims(candidates)
        challenges = resolveConflicts(claims)
        assignments = buildConsensus(claims, challenges)
```

**Output:** Lead expert, support experts, excluded experts, rationale

### Stage 4: EXECUTE

Lead expert executes task with support.

- Lead owns the output
- Support provides input when requested
- Handoff possible mid-task if scope changes

**Output:** Task artifacts (code, docs, analysis, etc.)

### Stage 5: REVIEW

Review experts examine output.

- Implementation Auditor: spec compliance
- QA Engineer: test coverage
- Security Architect: vulnerabilities (if applicable)
- Original Lead: integration with intent

**Output:** Approved, revision needed, or blocked

---

## Expert Specification

Each expert declares:

```yaml
expert:
  id: "systems-architect"
  name: "Principal Systems Architect"
  
  # What activates this expert
  triggers:
    primary: [architecture, distributed, API design]
    secondary: [microservices, scalability]
  
  # What this expert owns
  domain:
    owns: [system design, service boundaries, tech selection]
    defers_to:
      implementation-engineer: "actual code"
      security-architect: "security requirements"
  
  # How this expert coordinates
  coordination:
    claim: "I own structural decisions and technology tradeoffs."
    confidence_thresholds:
      lead: 0.8
      support: 0.5
      observe: 0.3
```

### Expert Communication

During coordination, experts communicate via structured claims:

```json
{
  "expert_id": "sre",
  "claim": "Performance tasks require measurement before optimization. I lead with profiling.",
  "relevance": "high",
  "defers_to": ["implementation-engineer"],
  "requires": []
}
```

Claims are:
- One sentence
- Scoped to expertise
- Explicit about handoffs
- Low token cost

---

## Coordination Economics

### Token Budget

| Coordination Depth | Token Budget | Justified When |
|-------------------|--------------|----------------|
| Instant | ~20 | Clear single-domain task |
| Quick | ~70-120 | Clear task, 1-2 experts |
| Standard | ~200-300 | Multi-domain, distinct ownership |
| Extended | ~400-600 | Ambiguous, overlapping expertise |

### ROI Model

```
Cost of coordination: ~200-500 tokens
Cost of wrong expert selection: ~2,000-5,000 tokens (rework)

Break-even: If coordination prevents rework 10% of the time, it pays for itself.
Actual prevention rate: ~30-40% for ambiguous tasks
Net ROI: Positive for any non-trivial task distribution
```

---

## Reliability

### Graceful Degradation

| Failure | Response |
|---------|----------|
| No experts match | Fall back to highest-priority expert with warning |
| Coordination timeout | Proceed with best candidate |
| Review loop stuck | Emit with human review flag |
| Expert produces invalid output | Retry once, then escalate |

### Circuit Breaker

If coordination fails repeatedly:
1. Enter degraded mode (keyword-only selection)
2. Log warning, notify maintainer
3. Auto-recover after 5 successful tasks

### Human Escalation

Certain conditions require human intervention:
- User explicitly overrides expert selection
- Review loop exceeds 3 iterations
- Security-critical task with low confidence

---

## Observability

### Required Metrics

| Metric | Target | Purpose |
|--------|--------|---------|
| Coordination tokens p95 | < 400 | Cost control |
| Expert selection accuracy | > 95% | Quality |
| Review iterations p95 | ≤ 2 | Efficiency |
| User override rate | < 5% | Calibration |

### Coordination Trace

Every task produces an inspectable trace:

```json
{
  "task_id": "task-001",
  "coordination": {
    "depth": "standard",
    "candidates": ["systems-architect", "implementation-engineer", "security-architect"],
    "claims": [...],
    "assignments": {
      "lead": "implementation-engineer",
      "support": ["security-architect"],
      "excluded": ["systems-architect"]
    },
    "token_cost": 187
  },
  "execution": {...},
  "review": {...}
}
```

Traces are:
- Always generated
- Stored for debugging
- Hidden from users by default
- Available on request

---

## Integration with Marge

### File Structure

```
system/
├── experts/
│   ├── _index.md           # Discovery and routing logic
│   ├── systems-architect.md
│   ├── implementation-engineer.md
│   └── ...
└── workflows/
    └── coordination.md     # Coordination protocol details
```

### AGENTS.md Integration

The main instruction file references this system as THE execution model—not as an optional mode.

```markdown
## Task Execution

Every task flows through the coordination pipeline:
1. INTAKE → ROUTE → COORDINATE → EXECUTE → REVIEW

There is no bypass. There is no "simple mode."
```

---

## User Controls

While the system is always-on, users retain control:

### Available Controls

| Control | How | When |
|---------|-----|------|
| Request specific expert | "@security-architect review this" | User knows what they want |
| Request trace visibility | "show me how you decided" | Debugging, learning |
| Override selection | "no, use the architect instead" | Correction |
| Disable review | "skip review for this" | Speed over safety (rare) |

### Not Available

- Disabling coordination entirely
- Selecting coordination depth manually
- Bypassing the pipeline

The system handles complexity so users don't have to.

---

## Implementation Roadmap

### Phase 1: Foundation (Current)

- [x] Expert files with trigger headers
- [x] Multi-expert selection as default (2-3)
- [x] Basic relevance scoring
- [ ] Claim protocol implementation
- [ ] Coordination depth detection

### Phase 2: Full Coordination

- [ ] Challenge rounds for contested ownership
- [ ] Mid-task handoff protocol
- [ ] Coordination trace generation
- [ ] Review loop integration

### Phase 3: Robustness

- [ ] Graceful degradation paths
- [ ] Circuit breaker implementation
- [ ] SLI collection and dashboards
- [ ] Golden test set validation

### Phase 4: Optimization

- [ ] User preference learning
- [ ] Expert memory across sessions
- [ ] Confidence calibration from feedback
- [ ] Token budget optimization

---

## References

- [MADP Technical Specification](madp_technical_specification.md)
- [Multi-Agent Deliberation Article](article_multi_agent_deliberation.md)
- [Expert System Index](../system/experts/_index.md)

---

**This document defines the core execution model for Marge. It is not a feature proposal—it is the system architecture.**
