# Marge Simpson — Drop-in Audit & Bugfix Workflow

A portable, framework-agnostic workflow for running audits and fixing bugs in any codebase.

## Features
- **Auto-detection**: Detects Node.js, Python, Go, Rust, .NET, and Java test stacks automatically.
- **Configurable**: Use `verify.config.json` for deterministic commands.
- **Cross-platform**: Works on Windows (PowerShell) and macOS/Linux (Bash).

## Install
Copy this folder into your repo root. That's it.

## Quick Start

### Prompt examples you can use
- `marge_simpson/prompt_examples/system_audit.md` - for full codebase audits
- `marge_simpson/prompt_examples/features_and_issues.md` - for bugs, features, improvements
- `marge_simpson/prompt_examples/questions_confirmations_prompt.md` - for questions and confirmations
- `marge_simpson/prompt_examples/multiple_prompts.md` - for combined requests

### Day-to-day workflow
1) Paste any prompt from `prompt_examples/`, then describe your request in the same message.
2) The assistant fixes issues linearly and MUST run automated verification after each fix:
   - macOS/Linux: `./marge_simpson/verify.sh fast`
   - Windows (PowerShell): `./marge_simpson/verify.ps1 fast`
3) You only reply again if the assistant is blocked from executing commands in your environment.

### For repos with no tests yet
Use `--skip-if-no-tests` (bash) or `-SkipIfNoTests` (PowerShell) to exit cleanly:
```bash
./marge_simpson/verify.sh fast --skip-if-no-tests
```

## Scripts

| Script | Description |
|--------|-------------|
| `verify.ps1` / `verify.sh` | Runs tests (auto-detect or config-based) |
| `cleanup.ps1` / `cleanup.sh` | Cleans old logs, suggests archiving |
| `test-marge.ps1` / `test-marge.sh` | Self-test suite (validates Marge scripts work correctly) |

## Configuration

Edit `verify.config.json` to specify custom commands:
```json
{
  "fast": ["npm test"],
  "full": ["npm ci", "npm test", "npm run build"]
}
```

If empty or missing, the scripts auto-detect your stack.

## Tracking Files

| File | Purpose |
|------|---------|
| `assessment.md` | Findings, root causes, verification evidence |
| `tasklist.md` | Prioritized tasks with Definition of Done |
| `instructions_log.md` | Append-only log of standing instructions |

## How to know what's left
Open `tasklist.md` and search for `- [ ]` (unchecked items).
