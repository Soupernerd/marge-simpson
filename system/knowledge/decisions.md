# Decisions

> Strategic choices with documented rationale. Searchable by tags.

## Entry Format

```markdown
### [D-###] Short decision title #tag1 #tag2
- **Date:** YYYY-MM-DD
- **Last Accessed:** YYYY-MM-DD
- **Context:** Why this decision was needed
- **Decision:** What was decided
- **Alternatives:** What else was considered
- **Rationale:** Why this option was chosen
- **Related:** P-### or PR-### entries
```

---

## Entries

### [D-001] Single source of truth for Next ID in assessment.md #tracking #architecture
- **Date:** 2026-01-26
- **Last Accessed:** 2026-01-26
- **Context:** Both assessment.md and tasklist.md referenced "Next ID" counters, creating risk of desync and duplicate MS-#### assignments
- **Decision:** assessment.md owns the canonical Next ID; tasklist.md references assessment.md for ID assignment
- **Alternatives:** (1) Dual counters with sync checks, (2) Separate ID file, (3) Auto-increment from file scan
- **Rationale:** Single source eliminates race conditions; assessment.md is read first in workflow anyway; minimal change to existing structure
- **Related:** MS-0001

### [D-002] ProcessStartInfo over cmd.exe wrapper for PowerShell execution #cli #security #windows
- **Date:** 2026-01-26
- **Last Accessed:** 2026-01-26
- **Context:** PowerShell CLI needed to execute shell commands; initial approach used `cmd.exe /c` wrapper which introduced injection risks and encoding issues
- **Decision:** Use `System.Diagnostics.ProcessStartInfo` with direct executable path and argument array
- **Alternatives:** (1) cmd.exe /c wrapper, (2) PowerShell -Command string, (3) Invoke-Expression
- **Rationale:** ProcessStartInfo provides: no shell interpretation of special chars, proper argument escaping, direct exit code capture, no intermediate shell overhead
- **Related:** MS-0002

### [D-003] Array expansion over word-splitting for Bash command execution #cli #security #unix
- **Date:** 2026-01-26
- **Last Accessed:** 2026-01-26
- **Context:** Bash CLI needed safe command execution; naive `$args` expansion causes word-splitting vulnerabilities with spaces/special chars
- **Decision:** Use `"${args[@]}"` array expansion pattern for all command arguments
- **Alternatives:** (1) Simple $args expansion, (2) eval with quoting, (3) xargs piping
- **Rationale:** Array expansion preserves argument boundaries exactly as passed; immune to IFS word-splitting; standard bash idiom for safe argument handling
- **Related:** MS-0002

### [D-004] Whitelist regex validation for MODEL parameter #security #validation #cli
- **Date:** 2026-01-26
- **Last Accessed:** 2026-01-26
- **Context:** MODEL environment variable and --model flag are interpolated into prompts; malicious values could inject instructions
- **Decision:** Validate against whitelist pattern `^[a-zA-Z0-9._/-]+$` before use
- **Alternatives:** (1) Blacklist dangerous chars, (2) Escape/quote values, (3) Enum of known models, (4) No validation (trust user)
- **Rationale:** Whitelist is strictest—only allows chars that appear in real model names (gpt-4, claude-3.5-sonnet, etc.); rejects anything suspicious; simple regex works cross-platform
- **Related:** MS-0003

### [D-005] Chunked expert files over monolithic expert document #tokens #architecture #performance
- **Date:** 2026-01-26
- **Last Accessed:** 2026-01-26
- **Context:** Original design had single large expert file (~15KB); every task loaded full file even when only one expert needed
- **Decision:** Split into individual expert files (architecture.md, security.md, etc.) loaded on-demand via workflow references
- **Alternatives:** (1) Single file with section markers, (2) Compressed/minified single file, (3) Dynamic generation
- **Rationale:** ~7.4x token reduction for typical tasks; experts only loaded when workflow requests them; easier maintenance; matches Unix philosophy of small focused tools
- **Related:** MS-0004
