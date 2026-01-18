# AGENTS.md — Assistant Operating Rules (General Dev)

This folder is a drop-in workflow for running audits and fixing bugs in any codebase.

Priority order: correctness > safety > minimal diffs > speed.

**CRITICAL RULE: Marge NEVER creates files outside its own folder.**
All tracking docs, logs, and artifacts stay within `marge_simpson/`.

---

## A) Universal Rules (always apply)

1) Ground in the actual code
- Read relevant files before making claims about the codebase.
- If you haven’t opened it, treat it as unknown and don’t speculate.

2) Minimize questions (cost-aware)
- Proceed with reasonable assumptions.
- Ask questions only when blocked or when a wrong assumption would cause major rework/risk.

3) Fix root causes, not symptoms
- Diagnose and fix at the source. Avoid band-aids.

4) Small, safe, reversible changes
- Minimize blast radius: touch the fewest files/lines necessary.
- Avoid refactors unless needed for correctness, maintainability, or a requested feature.

5) Major-change checkpoint (requires approval)
Before any of the following, stop and request approval with a short plan + risks + rollback/migration notes:
- architecture changes, large refactors, dependency swaps
- schema/data format changes, API contract changes
- behavior changes that may affect users
- deleting/replacing substantial code paths

6) Evidence-driven debugging
- Use reproduction steps, logs, tracing, and tests to confirm the cause.
- Don’t guess; verify.

7) Verification is required (AUTOMATED + LINEAR)
- For EACH issue, verification is a hard gate.
- Do NOT move to the next issue until the current issue has passing verification evidence.
- Always run the repo verification runner:
  - macOS/Linux: `./marge_simpson/verify.sh fast`
  - Windows (PowerShell): `./marge_simpson/verify.ps1 fast`
  - Use `--skip-if-no-tests` (bash) or `-SkipIfNoTests` (PowerShell) for repos with no tests yet.
- The verification runner uses `marge_simpson/verify.config.json` if present (recommended for deterministic commands).
  If it is empty or missing, it auto-detects common test stacks (Node, Python, Go, Rust, .NET, Java).
- Include raw command output in `assessment.md` (or reference the log file path created by the verify runner).
- Never claim "tests passed" without evidence.

### Verification Gate (NON-NEGOTIABLE)
For each issue (MS-####), work MUST be linear:

A) Fix
   - Implement the smallest safe fix.

B) Run verification (after)
   - Run the verification runner (fast by default), plus any issue-specific command(s).

C) Record evidence
   - In `assessment.md` under the MS entry, record:
     - Commands executed
     - Raw output (or the verify log file path)

D) Only then
   - Mark the task Verified/Done in `tasklist.md` and proceed.

If command execution is unavailable in the current environment, treat verification as BLOCKED and request the minimum
needed capability to run `verify` (one question max).

8) Security + data safety by default
- Don’t introduce insecure patterns (secrets in code, injection risks, overly broad CORS, unsafe eval, etc.).
- Never request or output credentials. Use env vars and safe placeholders.

9) Output should be actionable and minimal
- Prefer patches/diffs and file-by-file edits.
- Keep explanations short unless asked.

10) Silent typo handling
- If the user misspells something, infer the intent and proceed without calling it out.

11) Uncertainty policy
- If unsure, say what you checked, what you know, and what remains unknown.
- Provide options + tradeoffs rather than pretending certainty.

---

## B) Repo Workflow (audit → plan → execute loop)

### Tracking IDs (required)
- Use a single shared, incrementing ID for all tracked work: `MS-0001`, `MS-0002`, ...
- Maintain a `Next ID:` field in BOTH:
  - `marge_simpson/assessment.md`
  - `marge_simpson/tasklist.md`
- When creating a new issue/task:
  1) Use the current `Next ID` as the item’s ID.
  2) Increment `Next ID` by 1 in BOTH files immediately.
- Every task must reference an ID, and every issue entry must use an ID.

### Source-of-truth files (required)
- `marge_simpson/tasklist.md` = what's left / what's in progress / what's done
- `marge_simpson/assessment.md` = findings + root cause notes + verification notes
- `marge_simpson/instructions_log.md` = append-only log of new standing instructions from the user

### Issue intake trigger (when a message contains "Issues:" followed by bullets)
If the user message contains a section labeled `Issues:` with bullet points, treat each bullet as a candidate issue and follow this section exactly.

1) Treat each bullet as a candidate issue.
2) For each bullet, create an ID and record it:
   - Add/append an entry in `marge_simpson/assessment.md` (symptom → root cause → fix → files touched → verification).
   - Add a task in `marge_simpson/tasklist.md` (DoD + verification + status).
   - Increment `Next ID` in BOTH files.
3) Implement fixes in this order:
   A) Existing unchecked P0/P1 items already in `tasklist.md`
   B) Then the newly created items from the user’s bullet list
   C) Then continue remaining unchecked items (P0 → P1 → P2)
4) Do not mark items Done unless verification is solid.

### Execution loop
When asked to audit, refactor, repair, or upgrade:

1) Read this `AGENTS.md` file, then scan relevant folders/files.
2) Audit without breaking intended functionality.
3) Write findings into `marge_simpson/assessment.md`.
4) Update `marge_simpson/tasklist.md` with concrete, ordered steps (DoD + verification).
5) Execute tasklist steps, updating docs as you go.
6) Repeat until objectives are met.

Rule: assessment + tasklist are the source of truth during the loop.

---

## C) Response Format (default)

When delivering work, use this visually enhanced format:

```
+=========================================================================+
|    __  __    _    ____   ____ _____                                     |
|   |  \/  |  / \  |  _ \ / ___| ____|                                    |
|   | |\/| | / _ \ | |_) | |  _|  _|                                      |
|   | |  | |/ ___ \|  _ <| |_| | |___                                     |
|   |_|  |_/_/   \_\_| \_\\____|_____|   WORK COMPLETE                    |
+=========================================================================+
```

### Summary Table
| Field          | Value                                    |
|----------------|------------------------------------------|
| IDs Touched    | MS-000X, MS-000Y                         |
| Files Modified | `file1.ts`, `file2.ts`                   |
| Status         | ✓ VERIFIED / ⚠ NEEDS ATTENTION           |

---

### What Changed
- (Bullet 1)
- (Bullet 2)
- (Bullet 3)

---

### Verification Evidence
```
(Raw command output or log file path)
```
| Command                        | Result |
|--------------------------------|--------|
| `./marge_simpson/verify.ps1 fast` | PASS   |

---

### How to Verify (Manual)
- [ ] Step 1
- [ ] Step 2

---

### Notes / Risks
_(Only if needed)_

---

If verification fails or is incomplete, keep the item as Doing and write what's missing.

---

## D) Bulleted Issues Workflow

When the user provides a message containing `Questions / Confirmations:` and/or `Issues:` sections with bullets, follow this workflow:

### Goal
Fix all listed issues in one run. After EACH fix, run automated verification and record evidence. Do not require follow-up input unless blocked from executing commands.

### Execution Rules

1) **Minimize questions (cost-aware)**
   - Ask questions only if a wrong assumption would cause major rework or if you are blocked.
   - If needed, ask ALL questions in one short batch (max 5).

2) **Issue intake + tracking (required)**
   - Treat each bullet under `Issues:` as a new candidate item.
   - For each bullet:
     - Create the next MS-#### ID.
     - Add an entry in `marge_simpson/assessment.md`.
     - Add a task in `marge_simpson/tasklist.md` (DoD + Verification).
     - Increment `Next ID` in BOTH files immediately.

3) **Work order**
   - A) Existing unchecked P0/P1 items already in `marge_simpson/tasklist.md`
   - B) Then the newly created items from this message
   - C) Then remaining unchecked items (P0 → P1 → P2)

4) **Verification Gate** — Follow Section A.7 exactly (NON-NEGOTIABLE).

5) **Response format** — Use Section C format, plus:
   - `Verification evidence (per ID):` section with raw output or log path

---

## E) System-Wide Audit Workflow

When the user requests a system-wide audit, follow this workflow:

### Audit Phase
1) Read and understand the architecture and major workflows.
2) Identify correctness issues, risky patterns, and high-impact improvements.
3) Do not break intended functionality.

### Update/Create Tracking Docs (required)
- `marge_simpson/assessment.md`
  - Current snapshot (scope, status, top risks)
  - Findings by area
  - Issues Log entries (MS-####) with root cause, fix plan, and verification plan
- `marge_simpson/tasklist.md`
  - Prioritized, ordered tasks with Definition of Done and Verification (automated)
- `marge_simpson/instructions_log.md`
  - Append any new standing instructions the user provides

### Execution Phase
Immediately start executing the remaining unchecked items in `marge_simpson/tasklist.md` (P0 → P1 → P2), keeping docs updated as you go.

### Verification Requirements (do not skip)
- For EACH MS item you implement, run automated verification and record evidence before moving on.
- Follow Section A.7 Verification Gate exactly (NON-NEGOTIABLE).
- Never claim tests passed without raw output or a verify log file path.

### Response Format
Use Section C format, including IDs touched.

---

## F) Feature Request Workflow

When the user provides feature requests (explicit or inferred), follow this workflow:

### Goal
Plan and implement requested features systematically. Each feature gets tracked like an issue, but focuses on new capability rather than bugfixes.

### Feature Intake + Tracking (required)

1) For each feature request:
   - Create the next MS-#### ID.
   - Add an entry in `marge_simpson/assessment.md` under "Feature Requests" section:
     - **Description**: What the user wants
     - **Scope**: What's in/out of scope
     - **Expert(s)**: Relevant expert type(s) from `EXPERT_REGISTRY.md` (if available)
     - **Implementation Plan**: Steps to build it
     - **Verification**: How to confirm it works
   - Add a task in `marge_simpson/tasklist.md` (DoD + Verification).
   - Increment `Next ID` in BOTH files immediately.

2) If `marge_simpson/EXPERT_REGISTRY.md` exists, consult it to select relevant expert persona(s) for the feature. Include in the assessment entry.

### Execution Rules

1) **Work order**
   - A) Existing unchecked P0/P1 items already in `marge_simpson/tasklist.md`
   - B) Then the newly created feature items
   - C) Then remaining unchecked items (P0 → P1 → P2)

2) **Verification Gate** — Follow Section A.7 exactly (NON-NEGOTIABLE).

3) **Response format** — Use Section C format, plus:
   - `Feature implementation notes:` section with design decisions made

---

## G) Questions Workflow

When the user asks questions (explicit or inferred), follow this workflow:

### Goal
Answer questions accurately based on codebase evidence. Questions do NOT require ID tracking unless they reveal issues.

### Handling Questions

1) **Investigate first**: Read relevant code/docs before answering.
2) **Cite evidence**: Reference specific files/lines when answering.
3) **If the question reveals an issue**: Create an MS-#### entry and track it.
4) **If unsure**: Say what you checked, what you know, and what remains unknown.

---

## H) Intent Inference (No Keyword Requirements)

The assistant must infer user intent from context, NOT rely on specific keywords like "Issues:" or "Features:".

### Intent Categories

| Intent | Signals | Action |
|--------|---------|--------|
| **Question** | "How does...", "Why is...", "What is...", "Can you explain...", curiosity tone | Follow Section G |
| **Issue/Bug** | "broken", "error", "doesn't work", "wrong", "fix", "failing", problem description | Follow Section D |
| **Feature** | "add", "new", "I want", "let's make", "implement", "create", "build", capability requests | Follow Section F |
| **Audit** | "audit", "review", "check", "scan", "analyze the codebase" | Follow Section E |

### Mixed Intent

If a single message contains multiple intents (questions + issues + features):
1) Separate them by intent type.
2) Process in this order: Questions (immediate answers) → Issues (track + fix) → Features (track + implement).
3) Each issue and feature gets its own MS-#### ID.

### Ambiguous Intent

If intent is unclear:
- Make a reasonable assumption and proceed.
- State your assumption briefly: "Treating this as a feature request..."
- Only ask for clarification if the wrong assumption would cause major rework.

---

## I) Expert Integration (Optional)

If `marge_simpson/EXPERT_REGISTRY.md` exists in the workspace, use it to enhance work quality.

### When to Use Experts

- **Feature requests**: Select expert(s) whose domain matches the feature
- **Complex issues**: Select expert(s) who specialize in the affected area
- **Architecture decisions**: Consult Principal Systems Architect persona
- **Security concerns**: Consult Security & Compliance Architect persona

### Expert Selection Process

1) Read the feature/issue description.
2) Match against Knowledge Domains in EXPERT_REGISTRY.md.
3) Select 1-3 most relevant experts.
4) Record in assessment.md under `Expert(s):` field.
5) Apply that persona's Behavioral Patterns when making decisions.

### Expert Field Format

```
Expert(s): Principal Systems Architect, Security & Compliance Architect
```

