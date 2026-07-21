---
name: daily
description: Create or update today's daily note with Todoist tasks, CRM follow-ups, and activity review. Use at start of day.
allowed-tools: Read Write Glob Grep mcp__todoist__find-tasks mcp__todoist__find-tasks-by-date
argument-hint: ""
---

# Daily Review

Create or update today's daily note with tasks and activity review.

## Configuration
```
VAULT_PATH="/Users/shark/Library/Mobile Documents/com~apple~CloudDocs/sharkvault"
```

All file operations use paths relative to VAULT_PATH.

## Usage
```
/daily
```

## Process

### 1. Create/Open Daily Note
- Calculate today's date: `YYYY-MM-DD`
- Check if `{VAULT_PATH}/daily/{YYYY-MM-DD}.md` exists
- If not, create from template
- If exists, append to existing content

### 2. Sync Todoist Tasks
Fetch tasks from Todoist MCP server:
- Get tasks due today or overdue
- Group by project -> domain mapping:
  - "Work" -> Work
  - "Projects" -> Business
  - "Home" -> Personal

Format in daily note:
```markdown
## Tasks

### Work
- [ ] Task 1
- [ ] Task 2

### Business
- [ ] Task 3

### Personal
- [ ] Task 4

### Overdue
- [ ] Overdue task (due: YYYY-MM-DD)
```

### 3. CRM Follow-ups
Query prospect pages for `next_action_date`:
- Find all prospects where `next_action_date <= today`
- Group by status (hot, warm, cold)

Add to daily note:
```markdown
## CRM Follow-ups

### Hot (Action Required)
- [[prospect-name]]: {next_action} (overdue by X days)

### Warm
- [[prospect-name]]: {next_action}

### Cold
- [[prospect-name]]: {next_action}
```

Create Todoist tasks for overdue follow-ups if not already created.

### 4. Recent Activity
Review `{VAULT_PATH}/wiki/log.md` for yesterday's entries:
```markdown
## Yesterday's Activity
- Ingested: X sources
- Created: Y entity/concept pages
- Updated: Z pages
```

### 5. Quick Capture Section
Add empty section for ad-hoc notes:
```markdown
## Notes

```

### 6. Log Operation
Add entry to `{VAULT_PATH}/wiki/log.md`:
```markdown
## {timestamp}

**Action**: daily
**Target**: daily/{YYYY-MM-DD}.md
**Summary**: Created daily note. {X} tasks synced, {Y} CRM follow-ups due.
```

## Daily Note Template

```markdown
---
type: daily
date: {YYYY-MM-DD}
---

# {Day of Week}, {Month DD, YYYY}

## Tasks

### Work

### Business

### Personal

### Overdue

## CRM Follow-ups

## Yesterday's Activity

## Notes

```

## Output
Report to user:
- Daily note at: `daily/{YYYY-MM-DD}.md`
- Tasks synced: X total (Y overdue)
- CRM follow-ups due: Z
- Any sync errors

## Error Handling
- Todoist unavailable: Note in daily, continue without tasks
- No prospects found: Skip CRM section
- Log read error: Skip activity section

## iCloud Safety
- Atomic file writes
- Single write operation for daily note
