# Release Checklist (Internal)

> Personal reference for pushing releases. Not part of repo.

---

## Pre-Release

1. Verify tests pass:
   ```powershell
   .\system\scripts\verify.ps1 fast
   ```

2. Update `VERSION` file:
   ```
   1.3.1
   ```

3. Update `CHANGELOG.md`:
   - Move items from `[Unreleased]` to `[X.Y.Z] - YYYY-MM-DD`
   - Add version link at bottom

4. Update tweets in `_tweets_for_marge.md` (optional)

---

## Commit & Push (PowerShell)

```powershell
# Stage all changes
git add -A

# Commit with release message
git commit -m "Release v1.3.1"

# Create version tag
git tag v1.3.1

# Push commit
git push

# Push tags
git push --tags
```

---

## Commit & Push (Bash/Git Bash)

```bash
git add -A && git commit -m "Release v1.3.1"
git tag v1.3.1
git push && git push --tags
```

---

## Post-Release

- [ ] Post release tweet
- [ ] Update GitHub release notes (optional)
- [ ] Verify global install works: `./cli/install-global.sh`

---

## Quick One-Liner (PowerShell)

```powershell
git add -A; git commit -m "Release vX.Y.Z"; git tag vX.Y.Z; git push; git push --tags
```

## Quick One-Liner (Bash)

```bash
git add -A && git commit -m "Release vX.Y.Z" && git tag vX.Y.Z && git push && git push --tags
```
