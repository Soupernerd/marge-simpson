# Meta-Development Guide

> How to improve Marge itself using Marge.

## Overview

Meta-development means improving the Marge system while using it. The `.meta_marge/` folder contains a copy of Marge's AGENTS.md and supporting files that **guide the AI to make improvements directly to the parent `marge-simpson/` folder**.

**Key concept:** You don't edit files in `.meta_marge/` and copy them back. Instead, `.meta_marge/AGENTS.md` tells the AI to audit and improve `marge-simpson/` directly, while tracking work in `.meta_marge/tracking/`.

## Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   Chat/IDE Mode              CLI Mode                          │
│   ─────────────              ────────                          │
│                                                          ┌───┐ │
│   convert-to-meta.ps1        marge meta init ←───────────│ S │ │
│          │                         │                     │ A │ │
│          │                         │                     │ M │ │
│          └────────────┬────────────┘                     │ E │ │
│                       ▼                                  │   │ │
│       ┌───────────────────────────────────┐              │ L │ │
│       │  .meta_marge/ (SINGLE SOURCE)     │──────────────│ O │ │
│       │  ├── AGENTS.md     (transformed)  │              │ G │ │
│       │  ├── tracking/ (preserved!)  │              │ I │ │
│       │  └── ...                          │              │ C │ │
│       └───────────────────────────────────┘              └───┘ │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

Both **Chat/IDE mode** and **CLI mode** use the same `.meta_marge/` folder as the single source of truth. Work tracked in tracking/ is preserved when switching between modes.

## Quick Start

### Option 1: CLI (Recommended)

```bash
# Set up meta-development
marge meta init

# Run a meta task
marge meta "run self-audit"

# Check status
marge meta status

# Reset to clean state (when starting fresh)
marge meta init --fresh
```

> **💡 Global Install:** Works even without a repo checkout. The global install includes `.dev/` in `~/.marge/shared/`, so `marge meta init` can create `.meta_marge/` anywhere.

### Option 2: Scripts (Full Control)

```bash
# Create meta guide folder
./.dev/meta/convert-to-meta.sh
# Creates: .meta_marge/ (gitignored)

# Run task
./cli/marge meta "run self-audit"
```

### Option 3: Chat/IDE

```
Read the .meta_marge/AGENTS.md file and follow it.
Run a self-audit on the marge-simpson codebase.
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `marge meta init` | Set up `.meta_marge/` (idempotent, preserves existing work) |
| `marge meta init --fresh` | Reset to clean state (clears tracked work) |
| `marge meta "task"` | Run task using `.meta_marge/` (prompts if missing) |
| `marge meta status` | Show meta-marge state and tracked work |
| `marge meta clean` | Remove `.meta_marge/` entirely |

## How It Works

```
marge-simpson/              ← Target of improvements (committed to git)
├── AGENTS.md               ← Production instructions
├── scripts/
├── workflows/
└── .meta_marge/            ← Meta guide (gitignored)
    ├── AGENTS.md           ← Says "audit marge-simpson/, not me"
    └── tracking/      ← Tracks meta-dev work
        ├── assessment.md   ← Issues found
        └── tasklist.md     ← Work queue

AI reads .meta_marge/AGENTS.md
      ↓
Audits marge-simpson/ folder
      ↓
Makes fixes directly to marge-simpson/
      ↓
Tracks work in .meta_marge/tracking/
```

## State Preservation

The `.meta_marge/tracking/` folder preserves your work across sessions:

- `marge meta init` — Won't overwrite existing work
- `marge meta init --fresh` — Explicit reset (you chose this)
- Switching between CLI and Chat/IDE — State is shared

If you run `marge meta init` with existing work, you'll see:

```
⚠ .meta_marge/ exists with tracked work:
  - 3 issues in assessment.md
  - 2 tasks in tasklist.md

Options:
  • Continue using existing setup (recommended)
  • marge meta init --fresh   (start over, loses tracked work)
```

## Scripts Reference

### Create Meta Guide
```bash
./.dev/meta/convert-to-meta.sh              # Creates .meta_marge/
./.dev/meta/convert-to-meta.sh -f           # Force overwrite existing
```

### PowerShell
```powershell
.\.dev\meta\convert-to-meta.ps1
.\.dev\meta\convert-to-meta.ps1 -Force
```

## Best Practices

1. **Use `marge meta init`** — It handles setup automatically
2. **Don't reset unnecessarily** — Work state is valuable
3. **Commit frequently** — Small, focused commits to marge-simpson/ make review easier
4. **Run tests** — Use `./scripts/verify.ps1 fast` after changes

## Folder Structure

```
.meta_marge/                  ← Meta guide (gitignored, NOT edited directly)
├── AGENTS.md                 ← Guides AI to improve marge-simpson/
├── workflows/                ← Reference for AI
├── experts/                  ← Reference for AI
├── knowledge/                ← Reference for AI
└── tracking/            ← AI tracks meta-dev work here
    ├── assessment.md         ← Issues found in marge-simpson/
    └── tasklist.md           ← Work queue for improvements
```

> **Note:** `.meta_marge/` has no `scripts/` folder — it uses `marge-simpson/scripts/` directly.

## Tips

- The `.meta_marge/` folder is gitignored — won't pollute commits
- Changes happen in `marge-simpson/`, not `.meta_marge/`
- CLI prompts to create `.meta_marge/` if missing
- Use `marge meta status` to see tracked work summary

## Known Behavior

### Expected Test Failure After Creation

After running `convert-to-meta.ps1`, you may see:

```
[FAIL] verify.ps1 -SkipIfNoTests exits 0 (returned: False)
```

**This is expected and harmless.** The test fails because:

1. Test Suite 4/5 in `test-marge.ps1` runs a nested `verify.ps1` call
2. The transformed `verify.config.json` contains paths like `.\.meta_marge\scripts\...`
3. These paths resolve incorrectly when run from *inside* `.meta_marge/` itself

**Impact:** One test failure in the verification summary. All other tests pass normally and meta-development workflow is unaffected.

**Note:** This is a testing artifact from the self-referential nature of `.meta_marge/` — the folder contains test scripts that try to verify themselves.
