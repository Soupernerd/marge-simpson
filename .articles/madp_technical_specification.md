# Multi-Agent Deliberation Protocol (MADP)

**Version:** 1.0.0-draft  
**Author:** Marge Crew  
**Status:** Technical Specification  

---

## Abstract

This document specifies the Multi-Agent Deliberation Protocol (MADP)—the coordination architecture for AI-assisted development. MADP defines how specialized agents are selected, how they coordinate, and how work flows through the system.

**MADP is not a feature. It is the runtime.**

Every task—from fixing a typo to redesigning an architecture—flows through the same protocol. The depth of coordination scales automatically. The interface to users is unchanged.

### Core Philosophy

> **"There is no single-agent mode. There is only the system."**

Traditional approaches treat multi-agent coordination as a special mode for complex tasks. MADP inverts this:

| Traditional | MADP |
|-------------|------|
| Single agent by default | Coordination by default |
| Deliberation when triggered | Depth scales continuously |
| User manages complexity | System absorbs complexity |
| Fallback for edge cases | The only execution path |

This isn't an optimization. It's a fundamentally different architecture.

---

## 1. Overview

### 1.1 Purpose

MADP defines the **standard operating mode** for AI-assisted development—not a fallback for edge cases, but the way every task is handled.

Every prompt flows through the same system:
1. Identify relevant specialists
2. Coordinate on approach and ownership
3. Execute with appropriate expertise
4. Review before shipping

The sophistication scales automatically. Simple tasks route quickly through minimal coordination. Complex tasks assemble full teams with extended deliberation. The protocol is the same; the depth adapts.

### 1.2 Scope

This protocol covers:
- Agent specialization and registration
- Task intake and complexity assessment
- Coordination phase mechanics
- Consensus and handoff protocols
- Review loop integration

### 1.3 Design Principles

| Principle | Description |
|-----------|-------------|
| **Always-on coordination** | Every task flows through expert coordination. Simple tasks resolve instantly; complex tasks deliberate longer. Same protocol, adaptive depth. |
| **Invisible orchestration** | Users submit prompts; the system handles everything else. No manual expert selection, no deliberation invocation, no process management. |
| **Minimal overhead** | Coordination adds value, not latency. Fast-path for clear tasks; deeper deliberation only when it helps. |
| **Explicit boundaries** | Agents know what they own and what they don't. |
| **Observable state** | All coordination artifacts are inspectable *if requested*, but hidden by default. |
| **Executable output** | Every coordination ends with actionable next steps. |

### 1.4 User Experience Contract

The protocol guarantees:

```
USER DOES                          SYSTEM DOES (automatically)
─────────────────────────────────────────────────────────────
Submits prompt          →          Identifies candidate experts
                        →          Coordinates ownership
                        →          Scales deliberation to complexity
                        →          Assigns lead + support
                        →          Executes task
                        →          Runs review loop
Receives result         ←          Returns artifacts
```

**Scaling behavior:**

| Task Complexity | Coordination Depth | Example |
|-----------------|-------------------|--------|
| Trivial | Instant routing (~50ms) | "fix this typo" |
| Simple | Single expert claims (~100ms) | "write a test for this function" |
| Moderate | 2-3 experts coordinate (~200ms) | "add JWT authentication" |
| Complex | Full deliberation (~500ms) | "redesign the data layer" |
| Ambiguous | Extended debate (~800ms) | "improve performance" |

**The user never needs to:**
- Ask "which expert should handle this?"
- Manually invoke deliberation
- Choose between competing approaches
- Understand the protocol internals
- Behave differently based on task complexity

---

## 2. Agent Specification

### 2.1 Agent Definition Schema

Each agent is defined by a specification file with the following structure:

```yaml
# agent-spec.yaml
agent:
  name: "Systems Architect"
  id: "systems-architect"
  version: "1.0.0"
  
  # Activation triggers (keywords that suggest this agent's relevance)
  triggers:
    primary:
      - architecture
      - distributed
      - API design
      - scalability
    secondary:
      - microservices
      - system design
      - high-level
  
  # Domain boundaries
  domain:
    owns:
      - "System architecture decisions"
      - "Service boundary definitions"
      - "API contract design"
      - "Technology selection with alternatives"
    defers:
      - implementation-engineer: "Actual code implementation"
      - security-architect: "Security requirements"
      - sre: "Operational concerns"
  
  # Deliberation behavior
  deliberation:
    # One-sentence scope claim for quick arbitration
    claim: "I own structural decisions—service boundaries, data flow, and technology tradeoffs."
    
    # Confidence thresholds
    confidence:
      high: 0.8    # Lead without deliberation
      medium: 0.5  # Participate in deliberation
      low: 0.3     # Observe only
    
    # Handoff triggers
    handoff_when:
      - "Implementation details finalized"
      - "Architecture decision made"
  
  # Category for grouping
  category: "engineering"
  
  # Priority for tiebreaking (1 = highest)
  priority: 1
```

### 2.2 Agent Registry

Agents are registered in a central index:

```
system/experts/
├── _index.md           # Discovery and routing logic
├── _registry.yaml      # Machine-readable agent manifest (optional)
├── systems-architect.md
├── implementation-engineer.md
├── security-architect.md
└── ...
```

### 2.3 Agent States

```
┌─────────────┐
│   IDLE      │ ← Not relevant to current task
└──────┬──────┘
       │ trigger match
       ▼
┌─────────────┐
│  CANDIDATE  │ ← Potentially relevant, awaiting deliberation
└──────┬──────┘
       │ deliberation outcome
       ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    LEAD     │     │   SUPPORT   │     │  EXCLUDED   │
│  (primary)  │     │ (secondary) │     │ (not needed)│
└─────────────┘     └─────────────┘     └─────────────┘
```

---

## 3. Task Intake

### 3.1 Task Structure

```typescript
interface Task {
  id: string;
  prompt: string;
  context: {
    files_mentioned: string[];
    code_snippets: string[];
    prior_conversation: Message[];
  };
  metadata: {
    timestamp: ISO8601;
    session_id: string;
  };
}
```

### 3.2 Complexity Assessment

Coordination depth is determined by multiple factors. The system assesses:

```typescript
interface ComplexityFactors {
  candidateCount: number;        // How many experts match
  confidenceVariance: number;    // How spread out are confidence scores
  domainOverlap: boolean;        // Do expert domains overlap
  actionClarity: boolean;        // Is the requested action clear
  scopeDefinition: boolean;      // Is the scope well-defined
}

function assessComplexity(task: Task, candidates: Agent[]): ComplexityFactors {
  return {
    candidateCount: candidates.length,
    confidenceVariance: statisticalVariance(candidates.map(a => a.confidence)),
    domainOverlap: hasOverlappingDomains(candidates),
    actionClarity: !containsVagueVerbs(task.prompt),
    scopeDefinition: hasClearDomainSignals(task.prompt)
  };
}

// Vague verbs that suggest unclear intent (one factor among many)
const VAGUE_VERBS = ['improve', 'fix', 'update', 'change', 'make better', 'optimize'];
```

**Key insight:** These factors influence coordination *depth*, not whether coordination happens. A task with all clear signals still flows through the system—it just resolves faster.
```

### 3.3 Relevance Scoring

```typescript
function computeRelevance(agent: Agent, task: Task): number {
  let score = 0;
  
  // Primary trigger matches (high weight)
  for (const trigger of agent.triggers.primary) {
    if (task.prompt.toLowerCase().includes(trigger.toLowerCase())) {
      score += 0.3;
    }
  }
  
  // Secondary trigger matches (medium weight)
  for (const trigger of agent.triggers.secondary) {
    if (task.prompt.toLowerCase().includes(trigger.toLowerCase())) {
      score += 0.15;
    }
  }
  
  // Context file type matching
  for (const file of task.context.files_mentioned) {
    if (agent.relevantFilePatterns.some(p => file.match(p))) {
      score += 0.1;
    }
  }
  
  return Math.min(score, 1.0);
}
```

---

## 4. Deliberation Protocol

### 4.1 Coordination Spectrum

Deliberation isn't binary (on/off)—it's a spectrum that scales with task complexity:

```
┌─────────────────────────────────────────────────────────────┐
│  COORDINATION SPECTRUM                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INSTANT      QUICK         STANDARD       EXTENDED        │
│  ROUTING      CLAIM         COORDINATION   DELIBERATION    │
│                                                             │
│  "fix typo"   "write test"  "add auth"     "improve perf"  │
│                                                             │
│  1 expert     1 expert      2-3 experts    3+ experts      │
│  ~0 tokens    ~50 tokens    ~150 tokens    ~400 tokens     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Every task flows through this system.** The depth of coordination adapts based on complexity factors:

```typescript
function determineCoordinationDepth(task: Task, candidates: Agent[]): CoordinationLevel {
  const factors = assessComplexity(task, candidates);
  
  // Single clear match = instant routing
  if (factors.candidateCount === 1 && candidates[0].confidence > 0.9) {
    return 'instant';
  }
  
  // Few candidates, high confidence = quick claim
  if (factors.candidateCount <= 2 && maxConfidence(candidates) > 0.7) {
    return 'quick_claim';
  }
  
  // Multiple experts with clear, distinct domains = standard coordination
  if (factors.candidateCount <= 3 && !factors.domainOverlap && factors.actionClarity) {
    return 'standard';
  }
  
  // Complex factors warrant extended deliberation
  // (many candidates, overlapping domains, unclear action, undefined scope)
  return 'extended';
}
```

### 4.2 Coordination Phases (Scaled by Depth)

All coordination levels flow through these phases—but time spent scales with complexity:

```
COORDINATION                     INSTANT    QUICK    STANDARD   EXTENDED
PHASE                            (~30ms)    (~100ms) (~200ms)   (~500ms)
────────────────────────────────────────────────────────────────────────
1. INTAKE: Parse task, match       ✓          ✓         ✓          ✓
   experts, assess complexity
   
2. CLAIM: Experts state scope      skip       brief     full       full
   (1 sentence each)               
   
3. CHALLENGE: Resolve overlaps     skip       skip      if needed  yes
   
4. CONSENSUS: Assign lead +        implicit   implicit  explicit   explicit
   support roles
────────────────────────────────────────────────────────────────────────
```

**Example flow for each level:**

| Level | Task | What Happens |
|-------|------|--------------|
| Instant | "fix typo in line 45" | Implementation Engineer claims → executes (~30ms) |
| Quick | "write test for UserService" | QA + Impl both relevant → QA claims testing → executes (~100ms) |
| Standard | "add JWT auth" | Architect + Security + Impl coordinate ownership → execute with review (~200ms) |
| Extended | "improve performance" | SRE + Arch + Impl + Security all claim → debate approach → measure first → execute (~500ms) |

### 4.3 Claim Message Format

```typescript
interface ClaimMessage {
  agent_id: string;
  claim: string;           // 1-sentence scope claim
  relevance: 'high' | 'medium' | 'low';
  defers_to?: string[];    // Agents better suited for parts of task
  requires?: string[];     // Agents needed for collaboration
}
```

**Example:**

```json
{
  "agent_id": "sre",
  "claim": "Performance issues require measurement before optimization. I should lead with profiling and observability.",
  "relevance": "high",
  "defers_to": ["implementation-engineer"],
  "requires": []
}
```

### 4.4 Challenge Message Format

```typescript
interface ChallengeMessage {
  challenger_id: string;
  challenged_id: string;
  reason: string;
  proposed_resolution: 'lead' | 'support' | 'collaborate' | 'exclude';
}
```

**Example:**

```json
{
  "challenger_id": "implementation-engineer",
  "challenged_id": "systems-architect",
  "reason": "This task is code-level optimization, not architectural redesign.",
  "proposed_resolution": "exclude"
}
```

### 4.5 Consensus Resolution

```typescript
interface ConsensusResult {
  task_id: string;
  deliberation_id: string;
  outcome: {
    lead: AgentAssignment;
    support: AgentAssignment[];
    excluded: AgentExclusion[];
  };
  rationale: string;
  token_cost: number;
}

interface AgentAssignment {
  agent_id: string;
  responsibility: string;
}

interface AgentExclusion {
  agent_id: string;
  reason: string;
}
```

**Example:**

```json
{
  "task_id": "task-001",
  "deliberation_id": "delib-001",
  "outcome": {
    "lead": {
      "agent_id": "sre",
      "responsibility": "Profile and identify bottlenecks"
    },
    "support": [
      {
        "agent_id": "implementation-engineer",
        "responsibility": "Optimize code once bottlenecks identified"
      }
    ],
    "excluded": [
      {
        "agent_id": "systems-architect",
        "reason": "Task is optimization, not architectural change"
      }
    ]
  },
  "rationale": "Measure-first principle: identify actual bottlenecks before optimizing.",
  "token_cost": 247
}
```

---

## 5. Execution Handoff

### 5.1 Handoff Protocol

Once deliberation completes, execution begins:

```
┌─────────────────────────────────────────────────────────────┐
│  LEAD AGENT                                                 │
│  - Receives full task context                               │
│  - Owns primary execution                                   │
│  - Can request support agent input                          │
│  - Responsible for final output                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ request_support()
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  SUPPORT AGENT                                              │
│  - Receives scoped sub-task                                 │
│  - Returns artifacts to lead                                │
│  - Does not modify lead's work directly                     │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Mid-Task Handoff

Agents may hand off leadership mid-task when scope becomes clearer:

```typescript
interface HandoffRequest {
  from_agent: string;
  to_agent: string;
  reason: string;
  task_state: {
    completed: string[];
    remaining: string[];
    artifacts: Artifact[];
  };
}
```

**Example:**

```json
{
  "from_agent": "sre",
  "to_agent": "implementation-engineer",
  "reason": "Profiling complete. Bottleneck identified in database query layer.",
  "task_state": {
    "completed": ["Profiling", "Bottleneck identification"],
    "remaining": ["Query optimization", "Caching implementation"],
    "artifacts": [
      {"type": "profile_report", "path": "analysis/profile.json"}
    ]
  }
}
```

---

## 6. Review Loops

### 6.1 Review Protocol

After execution, review agents examine output:

```
┌─────────────────────────────────────────────────────────────┐
│  EXECUTION COMPLETE                                         │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  REVIEW PHASE                                               │
│  Activated agents:                                          │
│  - implementation-auditor (code review)                     │
│  - qa-engineer (test coverage)                              │
│  - security-architect (if security-relevant)                │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  REVIEW OUTCOMES                                            │
│  - APPROVED: Output ships                                   │
│  - REVISION_NEEDED: Back to lead with feedback              │
│  - BLOCKED: Critical issue, requires deliberation           │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Review Message Format

```typescript
interface ReviewResult {
  reviewer_id: string;
  verdict: 'approved' | 'revision_needed' | 'blocked';
  findings: Finding[];
  token_cost: number;
}

interface Finding {
  severity: 'critical' | 'major' | 'minor' | 'suggestion';
  location?: string;
  description: string;
  suggested_fix?: string;
}
```

---

## 7. Observability

### 7.1 Service Level Indicators

MADP implementations SHOULD track these metrics:

| SLI | Target | Measurement |
|-----|--------|-------------|
| Coordination token cost | p95 < 400 tokens | Tokens spent in coordination phase |
| Expert selection accuracy | > 95% | Validated against golden test set |
| Review loop iterations | p95 ≤ 2 | Number of revision cycles before approval |
| User override rate | < 5% | Times user manually corrects expert selection |

### 7.2 Coordination Trace

All coordination sessions produce an observable trace:

```typescript
interface CoordinationTrace {
  id: string;
  task_id: string;
  timestamp: ISO8601;
  duration_ms: number;
  
  phases: {
    intake: {
      candidates: string[];
      complexity_factors: ComplexityFactors;
      coordination_depth: CoordinationLevel;
    };
    claims: ClaimMessage[];
    challenges: ChallengeMessage[];
    consensus: ConsensusResult;
  };
  
  token_usage: {
    intake: number;
    claims: number;
    challenges: number;
    consensus: number;
    total: number;
  };
}
```

### 7.2 Trace Storage

Traces are stored for debugging and improvement:

```
.marge/
└── deliberations/
    ├── delib-001.json
    ├── delib-002.json
    └── ...
```

---

## 8. Coordination Economics

### 8.1 Cost Model

| Phase | Typical Tokens | When Incurred |
|-------|---------------|---------------|
| Expert scanning | ~20 | Always |
| Header reading | ~50-100 | Always |
| Claim generation | ~100 | Standard+ coordination |
| Challenge round | ~100-200 | Extended coordination |
| Consensus | ~50 | Standard+ coordination |
| **Total (instant routing)** | **~20** | Clear single-expert tasks |
| **Total (quick claim)** | **~70-120** | Clear tasks |
| **Total (standard coordination)** | **~200-300** | Multi-expert tasks |
| **Total (extended deliberation)** | **~400-600** | Ambiguous tasks |

### 8.2 Cost-Benefit Analysis

```
Without MADP:
- Ambiguous task → wrong agent selected → rework
- Rework cost: ~2,000-5,000 tokens (re-execution)

With MADP:
- Ambiguous task → deliberation (~400 tokens) → right agent
- Net savings: ~1,600-4,600 tokens on ambiguous tasks
```

---

## 9. Reliability & Graceful Degradation

### 9.1 Failure Modes

| Failure | Detection | Response |
|---------|-----------|----------|
| No experts match | Candidate list empty | Fall back to general-purpose mode with warning |
| All experts match equally | Variance below threshold | Use priority ranking as tiebreaker |
| Coordination timeout | Exceeds time budget | Proceed with highest-confidence expert |
| Review loop stuck | > 3 iterations | Emit with warning, request human review |
| Expert produces invalid output | Schema validation fails | Retry once, then escalate to human |

### 9.2 Circuit Breaker

If coordination fails repeatedly:

```
IF coordination_failures > 3 IN last_10_tasks:
    ENTER degraded_mode
    LOG warning
    NOTIFY maintainer
    
# Degraded mode: skip coordination, use keyword-based expert selection
# Auto-recover after 5 successful tasks
```

### 9.3 Human Escalation

Certain conditions require human intervention:

- User explicitly requests different expert
- Review loop exceeds maximum iterations
- Coordination produces conflicting assignments
- Security-critical task with low confidence

---

## 10. Implementation Checklist

### 10.1 Core System (Required)

These components form the MADP runtime—the system is incomplete without them:

- [ ] **Expert registry** with trigger-based discovery
- [ ] **Coordination pipeline** (intake → route → coordinate → execute → review)
- [ ] **Depth scaling** algorithm (instant/quick/standard/extended)
- [ ] **Claim protocol** for expert ownership
- [ ] **Lead/Support assignment** with explicit handoff
- [ ] **Review loop** integration (always runs, depth varies)
- [ ] **Coordination trace** generation (for observability)

### 10.2 Robustness (Recommended)

These make the system production-ready:

- [ ] **Challenge rounds** for contested ownership
- [ ] **Mid-task handoff** protocol
- [ ] **Graceful degradation** (circuit breaker, fallbacks)
- [ ] **Token budget** tracking and limits
- [ ] **SLI collection** (accuracy, latency, iteration count)
- [ ] **Golden test set** for validation

### 10.3 Advanced (Future)

- [ ] User preference learning
- [ ] Expert memory across sessions
- [ ] Confidence calibration
- [ ] Dynamic expert loading

---

## 11. Appendix

### A. Example Coordination Session

**Task:** "Improve the performance of our API"

**Phase 1: Candidate Detection**
```
Candidates identified:
- systems-architect (relevance: 0.6)
- implementation-engineer (relevance: 0.5)
- sre (relevance: 0.7)

Complexity assessment:
- Candidate count: 3 (multiple perspectives needed)
- Confidence variance: low (no clear leader)
- Action clarity: low ("improve" is vague)

Coordination depth: EXTENDED
```

**Phase 2: Claims**
```
[systems-architect]:
"Performance could be architectural—caching strategy, service boundaries, 
data flow. I lead if it's structural redesign."
Relevance: medium
Defers to: implementation-engineer (code-level), sre (measurement)

[implementation-engineer]:
"If it's code-level—query optimization, algorithm efficiency, 
loop performance—that's my domain."
Relevance: medium
Requires: Profiling data to identify targets

[sre]:
"We should measure before we optimize. Profiling and observability 
identify actual bottlenecks. Start with me."
Relevance: high
Defers to: implementation-engineer (once bottlenecks identified)
```

**Phase 3: Consensus**
```
Lead: sre
Responsibility: Profile API, identify bottlenecks, establish baselines

Support: implementation-engineer
Responsibility: Optimize code once bottlenecks identified

Excluded: systems-architect
Reason: Task is optimization of existing system, not architectural change

Rationale: "Measure first" principle prevents premature optimization.
```

**Token cost:** 312 tokens

---

### B. Protocol Versioning

| Version | Changes |
|---------|---------|
| 1.0.0 | Initial specification |

---

### C. References

- [Marge Framework](https://github.com/soupernerd/marge-simpson)
- [Multi-Agent Deliberation Article](article_multi_agent_deliberation.md)
- [Implementation Plan](multi_agent_deliberation.md)

---

*This specification is part of the Marge framework for Multi-Agent Deliberation in AI-assisted development.*
