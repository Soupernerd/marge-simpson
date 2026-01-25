# MS-0001: System Folder Restructure

> Move `experts/`, `knowledge/`, `workflows/`, `tracking/`, and `scripts/` into a new `system/` folder.

**Status:** ✅ Complete  
**Created:** 2026-01-24  
**Completed:** 2026-01-24

---

## Goal

Clean up the root folder by grouping all AI-managed folders under `system/`.

## Current Structure (BEFORE)
```
marge-simpson/
├── AGENTS.md
├── AGENTS-lite.md
├── experts/           ← AI reference
├── knowledge/         ← AI memory
├── workflows/         ← AI processes
├── tracking/          ← AI work state
├── scripts/           ← AI automation
├── cli/
├── prompts/
├── .dev/
└── (config files)
```

## Target Structure (AFTER - IMPLEMENTED)
```
marge-simpson/
├── AGENTS.md
├── AGENTS-lite.md
├── system/            ← NEW: all AI-managed content
│   ├── experts/
│   ├── knowledge/
│   ├── workflows/
│   ├── tracking/
│   └── scripts/
├── cli/
├── prompts/
├── .dev/
└── (config files)
```

## Implementation Steps

### Phase 1: Move Folders ✅
- [x] Create `system/` directory
- [x] Move `experts/` → `system/experts/`
- [x] Move `knowledge/` → `system/knowledge/`
- [x] Move `workflows/` → `system/workflows/`
- [x] Move `tracking/` → `system/tracking/`
- [x] Move `scripts/` → `system/scripts/`

### Phase 2: Update Path References ✅
Files updated (path patterns):
- `./experts/` → `./system/experts/`
- `./knowledge/` → `./system/knowledge/`
- `./workflows/` → `./system/workflows/`
- `./tracking/` → `./system/tracking/`
- `./scripts/` → `./system/scripts/`

### Phase 3: Update convert-to-meta Scripts ✅
Both `.dev/meta/convert-to-meta.ps1` and `.sh` updated:
- Path transformations for system/ structure
- Scripts still use source folder for verification

### Phase 4: Update Tests ✅
- All test scripts updated with new folder detection (go up 2 levels now)
- `test-general.ps1` / `.sh` - required files paths updated
- `test-cli.ps1` / `.sh` - folder detection updated
- `verify.config.json` - command paths updated

### Phase 5: Update Documentation ✅
- `README.md` - folder structure, paths updated
- `.dev/ARCHITECTURE.md` - diagrams, paths updated
- `AGENTS.md` - all path references updated

### Phase 6: Verify ✅
- [x] Run `./system/scripts/verify.ps1 fast` - **ALL 4/4 TESTS PASSED**

---

## Rollback Plan

If issues arise:
```powershell
# Reverse the moves
Move-Item -Path "system\experts" -Destination "experts"
Move-Item -Path "system\knowledge" -Destination "knowledge"
Move-Item -Path "system\workflows" -Destination "workflows"
Move-Item -Path "system\tracking" -Destination "tracking"
Move-Item -Path "system\scripts" -Destination "scripts"
Remove-Item -Path "system" -Force
# Then git checkout to restore file contents
```

---

## Notes

- AGENTS.md stays at root (convention)
- cli/ stays at root (user entry point)
- prompts/ stays at root (user templates)
- .dev/ stays at root (hidden, meta-development)
