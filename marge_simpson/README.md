# Marge Simpson — Drop-in AI Workflow

A portable workflow that teaches any AI assistant to audit codebases and fix bugs systematically.

## Features
- **Automated verification** — Auto-detects Node.js, Python, Go, Rust, .NET, Java test stacks
- **Tracked work** — Every fix gets an ID (`MS-0001`, `MS-0002`, …) with root cause + verification
- **Cross-platform** — Works on Windows (PowerShell) and macOS/Linux (Bash)
- **Prompt templates** — Copy-paste prompts for common workflows

---

## Install (30 seconds)

1. Copy this folder into your repo root
2. Use a prompt template below

> **💡 Renamed the folder?** Replace `marge_simpson` with your folder name in prompts.

---

## Prompt Templates

### 🔍 System Audit (use first, or periodically)
Scans your codebase, creates a prioritized task list, and starts fixing issues.

```
Read the AGENTS.md file in the marge_simpson folder and follow it.

Run a system-wide audit of this workspace/repo.
- Read and understand the architecture and major workflows.
- Identify correctness issues, risky patterns, and high-impact improvements.
- Do not break intended functionality.

Update/create tracking docs:
- marge_simpson/assessment.md (snapshot + findings + new MS issues)
- marge_simpson/tasklist.md (prioritized tasks with DoD + verification)
- marge_simpson/instructions_log.md (append any new standing instructions I give)

Then immediately start executing the remaining unchecked items in marge_simpson/tasklist.md (P0 → P1 → P2), keeping docs updated as you go.
Output using the Response Format (include IDs touched).
```

---

### 🐛 Features & Issues (daily driver)
Report bugs or request features. Each becomes tracked work.

```
Read the AGENTS.md file in the marge_simpson folder and follow it.

New Feature / Issues:
- (describe your issue or feature request)

After finished above, search for and complete remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

---

### 📝 Instructions
Give direct instructions without the feature/issue format.

```
Read the AGENTS.md file in the marge_simpson folder and follow it.

Instruction:
- (your instruction here)
- (another instruction here)

After finished above, search for and complete remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

---

### ❓ Questions & Confirmations
Ask questions or confirm fixes. Quick answers grounded in code.

```
Read the AGENTS.md file in the marge_simpson folder and follow it.

Questions / Confirmations:
1. (your question here)
2. "MS-00xx fixed" (to confirm a fix worked)

After answering the questions above, search for and complete remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

---

### 🔀 Combined (questions + issues together)
Mix questions and issues in one prompt for efficiency.

```
Read the AGENTS.md file in the marge_simpson folder and follow it.

Questions / Confirmations:
1. (your question here)

New Feature / Issues:
- (your issue here)

After finished above, search for and complete remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

---

## What's Inside

| File | Purpose |
|------|---------|
| `AGENTS.md` | Rules the assistant follows |
| `assessment.md` | Findings + root cause + verification evidence |
| `tasklist.md` | Prioritized tasks (backlog → in-progress → done) |
| `instructions_log.md` | Your standing instructions (preserved across sessions) |
| `verify.ps1` / `verify.sh` | Automated test runner |
| `verify.config.json` | Custom test commands (optional) |
| `prompt_examples/` | Ready-to-copy prompt templates |

---

## Configuration

Edit `verify.config.json` to specify custom test commands:
```json
{
  "fast": ["npm test"],
  "full": ["npm ci", "npm test", "npm run build"]
}
```

If empty, the scripts auto-detect your stack.

For repos with no tests yet:
```bash
./marge_simpson/verify.sh fast --skip-if-no-tests
```

---

## Philosophy

| Principle | What it means |
|-----------|---------------|
| **Code first** | Read files before making claims |
| **Root causes** | Fix the source, not symptoms |
| **Minimal diffs** | Touch fewest files necessary |
| **Verification** | Tests pass or it's not done |
| **Tasklist is truth** | One source of what's left |
