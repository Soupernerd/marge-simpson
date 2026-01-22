Read the AGENTS.md file in the marge_simpson folder and follow it.

Run a system-wide audit of this workspace/repo (read-only).
- Read and understand the architecture and major workflows.
- Identify correctness issues, risky patterns, and high-impact improvements.
- Do not break intended functionality.

Update/create tracking docs:
- marge_simpson/assessment.md (snapshot + findings + new MS issues)
- marge_simpson/tasklist.md (prioritized tasks with DoD + verification)
- skip adding this instruction to marge_simpson/instructions_log.md

Iterative audit loop

After completing all steps above, rerun this same audit prompt and repeat the full review to catch:
- false positives
- missed issues
- newly introduced issues from fixes/refactors

Loop rules:
- Each pass must include: re-scan → validate findings → update outputs → re-check affected areas.
- Keep a short “Pass N” log of what was found/confirmed/cleared.
- Continue looping until a full pass produces **zero new issues** and **zero unresolved false positives**.

Once those cycles have happend list ALL unchecked items (if any exist) in marge_simpsons/tasklist.md (P0 → P1 → P2). Suggest order of operations.

Output using the Response Format (include IDs created).
 -explain each issue in concise detail, and where the problems lie