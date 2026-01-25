# Meta Tests

> Scripts for testing Marge's user scenarios during meta-development.

These tests simulate the five user types to verify all workflows function correctly.

## User Types Tested

| # | User Type | Has CLI? | `.marge/` Created? | AGENTS Used |
|---|-----------|----------|-------------------|-------------|
| 1 | CLI Global User | ✅ | ✅ via `marge init` | Full `AGENTS.md` |
| 2 | Drop-in Folder User | ❌ | ❌ | `./AGENTS.md` |
| 3 | Hybrid User | ✅ | Mixed | Local wins |
| 4 | CLI Lite Mode User | ✅ | ❌ | `AGENTS-lite.md` |
| 5 | IDE-only User | ❌ | ❌ | `./AGENTS.md` |

## Scripts

| Script | Purpose |
|--------|---------|
| `test-scenarios.ps1` | PowerShell scenario tests (27 tests) |
| `test-scenarios.sh` | Bash equivalent |

## Usage

Run from the `marge-simpson/` folder:

```powershell
# Windows - Run all scenarios
.\.dev\meta\meta_tests\test-scenarios.ps1

# Run specific scenario
.\.dev\meta\meta_tests\test-scenarios.ps1 -Scenario Global
.\.dev\meta\meta_tests\test-scenarios.ps1 -Scenario DropIn
.\.dev\meta\meta_tests\test-scenarios.ps1 -Scenario Hybrid
.\.dev\meta\meta_tests\test-scenarios.ps1 -Scenario Lite
.\.dev\meta\meta_tests\test-scenarios.ps1 -Scenario IDE

# Keep temp directories for inspection
.\.dev\meta\meta_tests\test-scenarios.ps1 -KeepTemp
```

```bash
# macOS/Linux
./.dev/meta/meta_tests/test-scenarios.sh
./.dev/meta/meta_tests/test-scenarios.sh --scenario global
./.dev/meta/meta_tests/test-scenarios.sh --scenario lite
```

## Scenarios Tested

| Scenario | What's Verified |
|----------|-----------------|
| **CLI Global** | Global install has shared resources, `.dev/` for meta, init works |
| **Drop-in Folder** | Required files, relative paths, scripts run, `.dev/` available |
| **Hybrid** | Local AGENTS.md used, global available, both coexist |
| **IDE-only** | AGENTS.md at root, prompts folder, tracking/, direct scripts |

## When to Run

- After changes to install scripts
- After changes to folder structure
- After changes to CLI init/clean commands
- Before releases
