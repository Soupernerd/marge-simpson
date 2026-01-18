# Marge Simpson - sMITten Recursive Context

# NOW with Automated Testing 🛠️

<p float="left">
  <img src="assets/2p1f.png" width="96%" />
</p>

## BATCHED Questions + Issues = BATCHED Answers + CLEAN Fixes

<p float="left">
  <img src="assets/question-issue.png" width="48%" />
  <img src="assets/response.png" width="48%" />
</p>

## Install (30 seconds)
1) Copy the **`marge_simpson/`** folder into your repo/workspace root.
2) Run the prompts below.

That's it!


## Your workflow (exactly how you use it)

### 1) Let's kickstart the system! (Also do this periodically as you see fit)

Paste this entire prompt into your assistant chat:

```txt
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

**What you get**
- a refreshed **plan** (tasklist)
- a refreshed **truth record** (assessment)
- the assistant immediately starts burning down remaining work

---

### 2) After kickstarting, This is your everyday, regular prompt!
Natural language, super simple.

Modify then Paste this entire prompt into your assistant chat:

```txt
Read the AGENTS.md file in the marge_simpson folder and follow it.

Questions / Confirmations:
1. (Question/confirmation here)
2. (Question/confirmation here)
3. Example Confirmation: "MS-00xx fixed"
4. Example Question: "Are there alternatives to codemirror?"

Issues:
- (Issue here)
- (Issue here)
- Example / New Issue: "The right hand side nav is expanding as expected, however it will not close"
- Example / Existing issue not fixed: "MS-0046 not fixed, still exibiting [insert issue here]"

After the issues above, continue remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

**How it behaves**
- questions get answered (briefly, grounded in code)
- each issue becomes tracked work (MS IDs) and gets fixed
- after that, it continues the remaining unchecked tasklist items automatically

---

## What it is
**Marge Simpson** is a small folder you drop into your workspace root that tells *any* AI assistant how to behave during coding work:

- read the real files first (no guessing)
- fix root causes (not band-aids)
- keep changes small and safe
- track work with a single incrementing ID (`MS-0001`, `MS-0002`, …)
- **automated verification** with auto-detected test stacks (Node, Python, Go, Rust, .NET, Java)
- keep two source-of-truth docs:
  - **`marge_simpson/tasklist.md`** (what's left / doing / done)
  - **`marge_simpson/assessment.md`** (root cause notes + verification)

---

## How to see what’s left

Simply ask your agent!

```txt
List remaining unchecked items (if any exist) in marge_simpson/tasklist.md
```

---

## Save money / time: verify in one batch
After you direct and test a bunch of fixes, reply once (instead of 10 times and losing fidelity):

```txt
Read the AGENTS.md file in the marge_simpson folder and follow it.

Questions / Confirmations:
1. (Question/confirmation here)
2. (Question/confirmation here)
3. Example Confirmation: "MS-00xx fixed"
2. Example Question: "Are there alternatives to codemirror?"

Issues:
- (Issue here)
- (Issue here)
- Example / New Issue: "The right hand side nav is expanding as expected, however it will not close"
- Example / Existing issue not fixed: "MS-0046 not fixed, still exibiting [insert issue here]"

After the issues above, continue remaining unchecked items (if any exist) in marge_simpson/tasklist.md (P0 → P1 → P2).
```

---

## What’s inside
```
marge_simpson/
  AGENTS.md               # The rules assistants follow
  assessment.md           # Findings + root cause + verification
  tasklist.md             # Prioritized tasks with DoD
  instructions_log.md     # Standing instructions from user
  verify.config.json      # Custom test commands (optional)
  verify.ps1 / verify.sh  # Automated test runner
  cleanup.ps1 / cleanup.sh # Log cleanup utility
  verify_logs/            # Timestamped verification logs
  prompt_examples/
    system_audit.md       # Full codebase audit
    issues_prompt.md      # Report issues
    questions_prompt.md   # Ask questions
    feature_prompt.md     # Request features
    multiple_prompts.md   # Combined requests
```

---

## Philosophy (why this works)
- **Open files before claims**
- **Fix the cause**
- **Small diffs**
- **Verification beats vibes**
- **Tasklist is reality**

---

## For Contributors: Creating a meta_marge

Want to improve Marge itself? Use the **meta development workflow**:

### What's the difference?
| Folder | Purpose |
|--------|---------|
| `marge_simpson/` | **Template for end users** - this gets copied to other repos |
| `meta_marge/` | **Development instance** - used to improve Marge itself |

### Quick Start
```powershell
# Windows PowerShell
.\convert-to-meta.ps1
```
```bash
# macOS/Linux
./convert-to-meta.sh
```

This creates `meta_marge/` by copying from `marge_simpson/` and updating internal references.

### Development Workflow
1. Run `convert-to-meta.ps1` (or `.sh`) to create/refresh `meta_marge/`
2. Use the prompts but reference `meta_marge` instead of `marge_simpson`
3. Make improvements, test with `./meta_marge/test-marge.ps1`
4. When satisfied, copy changes back to `marge_simpson/` (the template)

### Key Files
```
meta_marge/
  AGENTS.md               # Edit this to change assistant behavior
  test-marge.ps1          # Self-test suite (15 tests)
  verify.ps1              # Verification runner
  cleanup.ps1             # Log cleanup utility
```

### Testing Your Changes
```powershell
# Run the self-test suite
.\meta_marge\test-marge.ps1

# Run verification
.\meta_marge\verify.ps1 fast -SkipIfNoTests
```

---

## License
Do whatever you want with it. Fork it, rename it, ship it with your team.
