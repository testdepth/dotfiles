---
name: lint
description: Health check for wiki integrity. Finds orphan pages, broken links, missing frontmatter, iCloud conflicts.
allowed-tools: Read Write Glob Grep
argument-hint: ""
---

# Wiki Lint

Health check for wiki integrity and quality.

## Configuration
```
VAULT_PATH="/Users/shark/Library/Mobile Documents/com~apple~CloudDocs/sharkvault"
```

All file operations use paths relative to VAULT_PATH.

## Usage
```
/lint
```

## Checks Performed

### 1. Orphan Pages
Find pages not linked from any other page:
- Scan all `.md` files in `{VAULT_PATH}/wiki/`
- Build link graph from wikilinks
- Identify pages with zero incoming links
- Exclude `index.md` and `log.md` from orphan check

Report:
```
Orphan pages (not linked from anywhere):
- wiki/work/entities/some-entity.md
- wiki/business/concepts/some-concept.md
```

Fix: Add links from relevant pages or index.md

### 2. Broken Links
Find wikilinks pointing to non-existent pages:
- Parse all `[[wikilinks]]` in wiki files
- Check each target exists
- Report broken links with source file

Report:
```
Broken links:
- wiki/work/sources/article.md -> [[non-existent-page]]
- wiki/business/entities/client.md -> [[old-service-name]]
```

Fix: Create missing page or update link

### 3. Missing Frontmatter
Check YAML frontmatter completeness:
- Each page type has required fields (per CLAUDE.md schemas)
- Validate field formats (dates as YYYY-MM-DD, arrays as lists)

Report:
```
Missing frontmatter:
- wiki/work/sources/article.md: missing 'date_ingested'
- wiki/business/entities/prospects/acme.md: missing 'status'
```

Fix: Add missing fields

### 4. Invalid Frontmatter Values
Check frontmatter values are valid:
- `status` fields have valid enum values
- `domain` matches file location
- `type` matches page location
- Dates are valid ISO format

Report:
```
Invalid frontmatter:
- wiki/business/entities/prospects/acme.md: status 'active' not valid (expected: cold|warm|hot|proposal|negotiating|lost)
```

### 5. Stale Pages
Find pages that may need attention:
- Source summaries older than 90 days without updates
- Prospects with `next_action_date` in the past
- Entities/concepts with only one source reference

Report:
```
Stale content:
- wiki/business/entities/prospects/old-lead.md: next_action_date 2024-01-15 (90 days overdue)
- wiki/work/concepts/old-methodology.md: only 1 source, last updated 2024-02-01
```

### 6. iCloud Conflicts
Find conflict files created by iCloud:
- Files matching `* 2.md`, `* 3.md`, etc.
- Files with ` (1).md` suffix

Report:
```
iCloud conflicts detected:
- wiki/work/sources/article 2.md (conflicts with article.md)
```

Fix: Manually review and merge, delete duplicate

### 7. Index Completeness
Verify `{VAULT_PATH}/wiki/index.md` links to all wiki pages:
- Scan all pages in `{VAULT_PATH}/wiki/`
- Check each has entry in index.md

Report:
```
Missing from index:
- wiki/business/entities/services/new-service.md
- wiki/personal/concepts/new-concept.md
```

### 8. Bidirectional Link Check
Verify links are bidirectional where expected:
- Source -> Entity should have Entity -> Source backlink
- Source -> Concept should have Concept -> Source backlink

Report:
```
Missing backlinks:
- wiki/work/sources/article.md links to [[person-name]] but person-name.md doesn't link back
```

## Output Summary

```
Wiki Health Report
==================

Orphan pages:      X
Broken links:      X
Missing frontmatter: X
Invalid values:    X
Stale content:     X
iCloud conflicts:  X
Missing from index: X
Missing backlinks: X

Total issues: XX

[Details listed above]
```

## Auto-fix Option

For safe fixes, offer to auto-correct:
- Add missing pages to index.md
- Add backlinks to entity/concept pages
- Update statistics in index.md

Unsafe fixes (require manual review):
- Resolve iCloud conflicts
- Delete orphan pages
- Update stale content

## Log Operation
Add entry to `{VAULT_PATH}/wiki/log.md`:
```markdown
## {timestamp}

**Action**: lint
**Summary**: Wiki health check. Found {X} issues: {breakdown by type}.
**Auto-fixed**: {list of auto-fixes applied, if any}
```
