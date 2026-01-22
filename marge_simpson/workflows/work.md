# Work Workflow

> Unified workflow for all trackable work: bugs, features, improvements, refactors.
> The "type" is a label, not a different process.

## When to Use

User wants something **done** - any of:
- Fix a bug / error / broken behavior
- Add a new feature / capability
- Improve / enhance existing functionality
- Refactor / clean up code

## Work Intake

### For FEATURES (type: feature)

1. Create the next MS-#### ID
2. Create plan file: `plans/[feature-name]_MS-####.md`
   - Copy from `plans/_template.md`
   - Fill in: Goal, Approach, Why, Risks
   - List sub-tasks (each gets own MS-#### ID)
3. Add entry to `assessment.md` referencing the plan
4. Add task(s) to `tasklist.md` with parent reference
5. Increment `Next ID` in BOTH files

### For BUGS/IMPROVEMENTS/REFACTORS

1. Create the next MS-#### ID
2. Add entry to `marge_simpson/assessment.md`:
   ```markdown
   ### [MS-####] Short description
   - **Type:** bug | feature | improvement | refactor
   - **Status:** In Progress
   - **Description:** What needs to be done
   - **Expert(s):** (if using experts/ - optional)
   - **Plan:** Steps to implement
   - **Verification:** How to confirm it works
   - **Files:** (fill in as you work)
   ```
3. Add task to `marge_simpson/tasklist.md`:
   ```markdown
   ### [MS-####] Short description
   - **Type:** bug | feature | improvement
   - **DoD:** What "done" looks like
   - **Verification:** `./marge_simpson/scripts/verify.ps1 fast`
   - **Status:** [ ] Not started
   ```
4. Increment `Next ID` in BOTH files

### For EXISTING work (ID already exists)

1. Find the MS-#### in `tasklist.md`
2. Mark it `In Progress`
3. Continue from where it left off

## Execution

### Work Order (priority)

1. **First:** Existing unchecked P0/P1 items in `tasklist.md`
2. **Then:** Newly created items from this message
3. **Finally:** Remaining items (P0 → P1 → P2)

### For Each Item

```
┌─────────────────────────────────────┐
│  1. IMPLEMENT                       │
│     - Make the smallest safe change │
│     - Update assessment.md with     │
│       files touched                 │
└──────────────┬──────────────────────┘
               ▼
┌─────────────────────────────────────┐
│  2. VERIFY                          │
│     - Run: ./marge_simpson/scripts/verify.ps1 fast │
│     - Run any item-specific tests   │
│     - Capture raw output            │
└──────────────┬──────────────────────┘
               ▼
┌─────────────────────────────────────┐
│  3. RECORD                          │
│     - Paste evidence in assessment  │
│     - Mark task done in tasklist    │
└──────────────┬──────────────────────┘
               ▼
┌─────────────────────────────────────┐
│  4. NEXT                            │
│     - Move to next item             │
│     - Or deliver if all done        │
└─────────────────────────────────────┘
```

### Verification Gate (NON-NEGOTIABLE)

**Do NOT mark done without evidence.**

- Run the verification runner
- Capture raw output (or log file path)
- Record in assessment.md
- Only THEN mark complete

## Labels (for tracking, not routing)

| Type | When to Use |
|------|-------------|
| `bug` | Something is broken / wrong |
| `feature` | Adding new capability |
| `improvement` | Enhancing existing functionality |
| `refactor` | Code cleanup, no behavior change |

The process is the same for all types. Labels help with prioritization and reporting.

## Mixed Work (Multiple Items)

If user provides multiple items:

1. Create MS-#### for each distinct piece of work
2. Each gets its own assessment entry and tasklist item
3. Execute in priority order
4. Verify each before moving to next

## Ambiguous Cases

| Situation | Resolution |
|-----------|------------|
| "Fix X" but X needs new code | Label as `bug`, implement what's needed |
| "Add Y" but it's really fixing missing behavior | Label as `feature`, doesn't matter |
| Not sure if bug or feature | Pick one, note your assumption, proceed |

The label is for humans. The process is the same.
