# Knowledge Index

> **DO NOT read knowledge files directly.** Grep for tags/keywords first, then read only matching entries.

## How to Use

1. Identify what you're looking for (topic, tag)
2. Grep the relevant file(s) for matches
3. Read only the specific matching entry/entries

**Example:**
```powershell
# Find decisions about authentication
Select-String -Path "marge-simpson/system/knowledge/decisions.md" -Pattern "#auth"

# Find all entries tagged with typescript
Select-String -Path "marge-simpson/system/knowledge/*.md" -Pattern "#typescript"
```

---

## File Reference

| File | Purpose | When to Add |
|------|---------|-------------|
| [decisions.md](decisions.md) | Strategic choices with rationale | After making architecture/tech decisions |
| [patterns.md](patterns.md) | Recurring behaviors observed | After noticing repeated user preferences |
| [preferences.md](preferences.md) | User's stated preferences | When user expresses how they like things done |
| [insights.md](insights.md) | Learned facts about codebase | After discovering non-obvious codebase info |
| [archive.md](archive.md) | Pruned entries (historical) | When entry meets prune criteria |

---

## Entry Format

Entries use simple format:
```markdown
### YYYY-MM-DD: Brief Title
Description of the learning. Use #tags for searchability.
```

No ID schemes required. Tags enable grep-based retrieval.

---

## Maintenance

**Adding entries:** Just append to the relevant file. No index update needed.

**Periodic review (optional):** Archive stale entries to `marge-simpson/system/knowledge/archive.md`
