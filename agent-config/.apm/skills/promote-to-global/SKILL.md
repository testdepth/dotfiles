---
name: promote-to-global
description: Promote a project-local skill, agent, or subagent to the central agent-config APM package so it becomes available across all tools (Claude, Cursor, Copilot) globally. Use when you've built something useful in a project and want it everywhere.
allowed-tools: Read Write Glob Grep Shell
argument-hint: "[path-to-primitive]"
---

# Promote to Global Agent Config

Promote a project-local primitive (skill, agent, or subagent) into the central APM package at `~/code/dotfiles/agent-config/.apm/`, making it available globally across Claude Code, Cursor, and GitHub Copilot.

## Global Config Location

```
AGENT_CONFIG_PATH="$HOME/code/dotfiles/agent-config"
SKILLS_DIR="$AGENT_CONFIG_PATH/.apm/skills"
AGENTS_DIR="$AGENT_CONFIG_PATH/.apm/agents"
```

## Usage

```
/promote-to-global [path]
```

If no path is given, scan the current project for promotable primitives and present a list.

## Process

### 1. Discover Primitives (if no path given)

Scan the current project for promotable primitives in these locations:

| Source | Pattern | Type |
|--------|---------|------|
| `.claude/skills/<name>/SKILL.md` | APM skill | skill |
| `.claude/commands/<name>.md` | Claude command | skill |
| `.cursor/rules/<name>.mdc` | Cursor rule | instruction |
| `.claude/agents/<name>.md` | Claude agent | agent |
| `.cursor/agents/<name>.md` | Cursor agent | agent |
| `.pi/agent/skills/<name>/SKILL.md` | Pi skill | skill |
| `.github/agents/<name>.agent.md` | Copilot agent | agent |
| `AGENTS.md` sections | Inline agents | agent |

Present the list and ask the user to select which primitive(s) to promote.

### 2. Check for Conflicts

Before promoting, check if a primitive with the same name already exists in the global config:

- `$SKILLS_DIR/<name>/SKILL.md` for skills
- `$AGENTS_DIR/<name>.agent.md` for agents

If a conflict exists:
- Show a diff of the two versions
- Ask: **Replace**, **Merge (keep both descriptions, combine content)**, or **Skip**

### 3. Read and Validate the Source

Read the source file and determine its type and format:

#### Skills (SKILL.md format)

Valid APM skill format has frontmatter with:
```markdown
---
name: <name>
description: <description>
allowed-tools: <space-separated tool list>
argument-hint: "<hint>"
---
```

If frontmatter is missing or incomplete, extract the information from the content and construct it:
- `name`: derive from filename or first heading
- `description`: derive from first paragraph or heading
- `allowed-tools`: infer from tool references in the content (Read, Write, Glob, Grep, Shell, mcp__*)
- `argument-hint`: infer from Usage section

#### Agents (.agent.md format)

Valid APM agent format has frontmatter with:
```markdown
---
name: <name>
description: <description>
---
```

If the source is a Claude agent (`.claude/agents/<name>.md`), it already has this format — copy as-is with the `.agent.md` extension.

If the source is a Pi skill with agent-like behavior, convert: extract the instructions into agent format.

#### Claude Commands

Claude commands (`.claude/commands/<name>.md`) are slash commands, not skills. Convert to skill format:
- Wrap the command body in SKILL.md frontmatter
- Infer `allowed-tools` from the content
- Set `argument-hint` from any argument documentation in the file

### 4. Determine Destination

| Source type | Destination |
|------------|-------------|
| skill / command | `$SKILLS_DIR/<name>/SKILL.md` |
| agent | `$AGENTS_DIR/<name>.agent.md` |

Use the filename stem as the name (e.g., `my-skill.md` → `my-skill`). Convert to kebab-case if needed.

### 5. Write to Global Config

1. Create the destination directory if needed
2. Write the (possibly converted) content to the destination path
3. Verify the written file reads back correctly

### 6. Validate APM Format

After writing, verify the primitive is valid by checking:
- Frontmatter parses correctly (name, description present)
- For skills: `allowed-tools` is present
- Content is non-empty below the frontmatter

### 7. Report and Next Steps

Report to the user:
```
Promoted: <source-path>
       → <dest-path>

To deploy globally, run:
  apply

This will run `apm install -g` via home-manager and deploy the primitive to:
  ~/.claude/skills/<name>/    (Claude Code)
  ~/.cursor/agents/<name>.md  (Cursor)
  ~/.copilot/agents/<name>.agent.md  (Copilot)
```

If multiple primitives were promoted, list all of them.

### 8. Optional: Remove from Project

Ask the user:
> Remove from project source location after promoting? (y/N)

If yes, delete the original source file/directory. Only do this for files that are now fully superseded by the global version (i.e., the project-local version has no project-specific customizations).

## Format Reference

### Skill frontmatter keys

| Key | Required | Description |
|-----|---------|-------------|
| `name` | yes | Slug name (kebab-case) |
| `description` | yes | One-sentence description for tool discovery |
| `allowed-tools` | yes | Space-separated list of tools the skill may use |
| `argument-hint` | no | Hint shown to user for arguments (use `""` if none) |

### Common `allowed-tools` values

- `Read` — reading files
- `Write` — writing files
- `Glob` — listing files by pattern
- `Grep` — searching file contents
- `Shell` — running shell commands
- `mcp__todoist__*` — Todoist MCP tools
- `mcp__nvim__*` — Neovim MCP tools
- `mcp__chrome-devtools__*` — Browser DevTools MCP tools

### Agent frontmatter keys

| Key | Required | Description |
|-----|---------|-------------|
| `name` | yes | Slug name (kebab-case) |
| `description` | yes | When to invoke — shown to tool for auto-selection |

## Error Handling

- **Source not found**: Show clear error, list what was searched
- **Global config not found**: Verify `~/code/dotfiles/agent-config/.apm/` exists; if not, error with instructions to run `apply` first
- **Write failure**: Report the error with the file path and permissions context
- **Invalid format after conversion**: Show the converted file for manual review before writing
