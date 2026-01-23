# Assessment
Purpose: Periodic, point-in-time assessments of repo/system status.

## Read First (REQUIRED)
AI/Agents must read `AGENTS.md` before working.

---

## Tracking (required)
- **Next ID:** MS-0022
  - Use this for the next new Issue/Task ID, then increment here AND in `planning_docs/tasklist.md`.

---

## Current Snapshot
- **Last updated:** 2025-01-23
- **Scope assessed:** Full marge-simpson folder audit (excluding .meta_marge)
- **Build/Run context:** Windows PowerShell, v1.2.1
- **Overall status:** ✅ Healthy
- **Top risks:**
  - PowerShell must use `-Encoding UTF8` when reading UTF-8 files
  - Shell scripts should avoid Unicode characters (em-dash, curly quotes)

---

## Known Invariants (Do Not Break)
- VERSION file must match CLI versions in cli/marge and cli/marge.ps1
- All scripts must have PS1/SH parity (both files must exist)
- No UTF-8 BOM in shell scripts
- No problematic Unicode (em-dash, curly quotes) in script files
- verify.config.json must define fast profile with test commands

---

## Findings (by area)
### 1) Test Infrastructure
**Observations**
- Created comprehensive general validation test suite (test-general.ps1/sh)
- Tests cover: encoding, version consistency, PS1/SH parity, required files, README consistency, workflow connectivity
- 87 total tests across 3 test suites (syntax: 11, general: 61, marge: 15)

**Issues**
- MS-0019: PowerShell Get-Content without `-Encoding UTF8` misreads UTF-8 as Windows-1252

**Recommendations**
- Always specify `-Encoding UTF8` in PowerShell when reading UTF-8 files
- Use Python for byte-level encoding fixes (safer than PowerShell string ops)

**Impact / Risk**
- Low - fixed and tested

### 2) Shell Script Encoding
**Observations**
- Several .sh files contained em-dash (U+2014) instead of double-dash (--)
- Box-drawing characters (U+2500 range) are acceptable in output

**Issues**
- MS-0018: Em-dash characters in shell scripts cause issues

**Recommendations**
- Use ASCII-only in shell scripts except for cosmetic output

**Impact / Risk**
- Low - all fixed

---

## Issues Log (root-cause oriented)
> Add one entry per issue investigated/fixed. Keep it factual and file-backed.

### [MS-0018] Em-dash encoding issues in shell scripts
- **Reported:** 2025-01-23
- **Status:** Done
- **Expert(s):** testing, devops
- **Symptom:** test-general.ps1 reports "problematic Unicode characters" in multiple .sh files
- **Root cause:** Em-dash (U+2014, bytes E2 80 94) used instead of double-dash (--)
- **Fix:** Python script (fix-encoding.py) replaced em-dash bytes with ASCII `--`
- **Files touched:** `scripts/cleanup.sh`, `scripts/decay.sh`, `scripts/status.sh`, `scripts/verify.sh`, `cli/install-global.sh`, `meta/convert-to-meta.sh`
- **Verification:**
  - Commands executed: `.\scripts\verify.ps1 fast`
  - Evidence: All 87 tests pass
- **Notes / follow-ups:** None

### [MS-0020] Missing -Help flag in marge-init.ps1
- **Reported:** 2025-01-23
- **Status:** Done
- **Expert(s):** devops
- **Symptom:** `marge-init.ps1 --help` fails with error instead of showing help
- **Root cause:** marge-init.ps1 missing `-Help` parameter definition
- **Fix:** Added `-Help` switch parameter with help text display
- **Files touched:** `cli/marge-init.ps1`
- **Verification:**
  - Commands executed: `.\cli\marge-init.ps1 -Help`
  - Evidence: Now displays help text correctly
- **Notes / follow-ups:** Bash version already had -h/--help support

### [MS-0021] scripts/_index.md missing test-syntax and test-general
- **Reported:** 2025-01-23
- **Status:** Done
- **Expert(s):** documentation
- **Symptom:** Documentation incomplete - didn't list all test scripts
- **Root cause:** scripts/_index.md not updated when test-syntax and test-general were added
- **Fix:** Added test-syntax and test-general entries to Quick Reference and Script Details
- **Files touched:** `scripts/_index.md`
- **Verification:**
  - Commands executed: `.\scripts\verify.ps1 fast`
  - Evidence: 87/87 tests pass
- **Notes / follow-ups:** None
