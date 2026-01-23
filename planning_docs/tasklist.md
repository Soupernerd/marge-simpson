# planning_docs/tasklist.md
Purpose: Single source of truth for active work. Keep this current as tasks are added/closed.
Rule: If it's being worked on, it must be here.

## Read First (REQUIRED)
AI/Agents must read `AGENTS.md` before working.

---

## Tracking (required)
- **Next ID:** MS-0022
  - Use this for the next new Issue/Task ID, then increment here AND in `planning_docs/assessment.md`.

---

## Active Priorities (Top 5)
1) (none - system healthy)
2) …
3) …
4) …
5) …

---

## Work Queue

### P0 — Must fix (breaking / core workflow)
(none)

### P1 — Should fix (important but not blocking)
(none)

### P2 — Nice to have (polish / refactor / cleanup)
(none)

---

## In Progress
(none)

---

## Done (recent)
- [x] **MS-0018 —** Fix em-dash encoding in shell scripts
  - **Completed:** 2025-01-23
  - **Expert(s):** testing, devops
  - **Verification:**
    - Commands run: `.\scripts\verify.ps1 fast`
    - Evidence: 87/87 tests pass

- [x] **MS-0019 —** Fix PowerShell UTF-8 encoding detection in test-general.ps1
  - **Completed:** 2025-01-23
  - **Expert(s):** testing, devops
  - **Verification:**
    - Commands run: `.\scripts\verify.ps1 fast`
    - Evidence: 61/61 general tests pass, 87 total tests pass

- [x] **MS-0020 —** Add -Help flag to marge-init.ps1
  - **Completed:** 2025-01-23
  - **Expert(s):** devops
  - **Verification:**
    - Commands run: `.\cli\marge-init.ps1 -Help`
    - Evidence: Displays help correctly

- [x] **MS-0021 —** Update scripts/_index.md with test-syntax and test-general
  - **Completed:** 2025-01-23
  - **Expert(s):** documentation
  - **Verification:**
    - Commands run: `.\scripts\verify.ps1 fast`
    - Evidence: 87/87 tests pass

- [x] **Create general validation tests —** test-general.ps1 and test-general.sh
  - **Completed:** 2025-01-23
  - **Expert(s):** testing
  - **Verification:**
    - 6 test categories: encoding, version, parity, files, README, workflows
    - 61 tests total, all passing
