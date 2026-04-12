---
name: ingest
description: Process a raw source file into the wiki. Creates source summary, extracts entities and concepts, updates index.
allowed-tools: Read Write Glob Grep
argument-hint: "<path>"
---

# Ingest Source

Process a raw source file and integrate it into the wiki.

## Configuration
```
VAULT_PATH="/Users/shark/Library/Mobile Documents/com~apple~CloudDocs/sharkvault"
```

All file operations use paths relative to VAULT_PATH.

## Usage
```
/ingest <path>
```

## Arguments
- `path`: Path to raw source file (relative to vault or absolute)

## Process

### 1. Validate Source
- Confirm file exists in `{VAULT_PATH}/raw/` directory
- Determine domain from path: `raw/work/`, `raw/business/`, `raw/personal/`
- Determine source type from subfolder: `articles/`, `documents/`, `meetings/`
- Read file content

### 2. Analyze Content
- Extract key information:
  - Title (from filename or document heading)
  - Author (if present)
  - Date created (if present)
  - Main topics and themes
- Identify entities mentioned (people, companies, products, projects, places)
- Identify concepts discussed (methodologies, patterns, ideas)
- Generate 3-5 key takeaways
- Note important quotes worth preserving

### 3. Create Source Summary
- Generate slug from title (lowercase, kebab-case)
- Create file at `{VAULT_PATH}/wiki/{domain}/sources/{slug}.md`
- Populate YAML frontmatter per schema
- Write summary with:
  - Key takeaways as bullet list
  - Important quotes in blockquotes
  - Context and background
  - Links to entities and concepts mentioned

### 4. Process Entities
For each entity identified:
- Check if entity page exists in `{VAULT_PATH}/wiki/{domain}/entities/`
- If exists: Add this source to the entity's `sources:` frontmatter list
- If new: Create entity page with minimal info, mark for enrichment

### 5. Process Concepts
For each concept identified:
- Check if concept page exists in `{VAULT_PATH}/wiki/{domain}/concepts/`
- If exists: Add this source to the concept's `sources:` frontmatter list
- If new: Create concept page with minimal info, mark for enrichment

### 6. Update Index
- Add source summary link to `{VAULT_PATH}/wiki/index.md` under appropriate section
- Maintain alphabetical order within sections
- Update statistics at bottom

### 7. Log Operation
Add entry to `{VAULT_PATH}/wiki/log.md`:
```markdown
## {timestamp}

**Action**: ingest
**Target**: wiki/{domain}/sources/{slug}.md
**Source**: {original raw path}
**Summary**: Processed {source_type} "{title}". Created source summary.
**Entities**: {list of entity pages created/updated}
**Concepts**: {list of concept pages created/updated}
```

## Output
Report to user:
- Source summary created at: `wiki/{domain}/sources/{slug}.md`
- Entities processed: X new, Y updated
- Concepts processed: X new, Y updated
- Index updated
- Any warnings (missing metadata, unclear entities, etc.)

## Error Handling
- File not in raw/: "Source must be in raw/ directory"
- Cannot determine domain: "Could not determine domain from path. Expected raw/{work|business|personal}/..."
- Duplicate source: "Source summary already exists. Use /lint to check for issues."

## iCloud Safety
- Write complete files atomically
- 500ms delay between file operations
- Log any conflicts detected
