# agent-config

Personal APM package — the single source of truth for agent primitives shared across Claude Code, Cursor, and GitHub Copilot.

## How it works

Primitives are authored once in `.apm/` and deployed to every tool's native directories when home-manager activates:

```
agent-config/.apm/       ← edit here (tracked in git)
  skills/
    daily/SKILL.md
    ingest/SKILL.md
    ...
  agents/
    gravity-design-expert.agent.md
    nvim-coach.agent.md
    ...

           ↓  apm install -g  (run by modules/cli/apm.nix on home-manager apply)

~/.claude/skills/        ← Claude Code
~/.claude/agents/
~/.cursor/agents/        ← Cursor
~/.copilot/agents/       ← GitHub Copilot
~/.agents/skills/        ← cross-client shared
```

The `modules/cli/apm.nix` Nix module runs `apm install -g` during home-manager activation, deploying all primitives to the right global tool directories.

## Adding a new skill

1. Create `.apm/skills/<name>/SKILL.md` with the required frontmatter:

```markdown
---
name: my-skill
description: What this skill does and when to invoke it.
allowed-tools: Read Write Glob Grep Shell
argument-hint: "<optional-arg>"
---

# My Skill

...instructions...
```

2. Run `apply` to deploy it everywhere.

## Adding a new agent

1. Create `.apm/agents/<name>.agent.md` with the required frontmatter:

```markdown
---
name: my-agent
description: What this agent does and when to use it.
---

You are...
```

2. Run `apply` to deploy it everywhere.

## Promoting a project-local primitive

Use the `promote-to-global` skill within any project to move a local skill, agent, or command into this package:

```
/promote-to-global
```

The skill walks you through selecting the primitive, validates the format, copies it here, and reminds you to run `apply`.

## Package structure

```
agent-config/
  apm.yml          # APM manifest (targets: claude, cursor, copilot)
  .gitignore       # excludes APM-generated outputs (.claude/, .cursor/, etc.)
  .apm/
    skills/        # self-contained capability bundles (SKILL.md + optional assets)
    agents/        # persona definitions (.agent.md files)
  README.md
```

The APM-generated output directories (`.claude/`, `.cursor/`, `.github/`, `.agents/`, `apm_modules/`) are gitignored — they are regenerated on every `apply`.

## Architecture decision record

| Concern | Tool |
|---|---|
| Portable skills and agents | APM (`agent-config/.apm/`) |
| Claude settings, auth, permissions | Nix (`modules/cli/claude.nix`) |
| Cursor MCP servers, CLI config | Nix (`modules/cli/cursor.nix`) |
| Pi installation and all config | Nix (`modules/cli/pi.nix`) |
| APM global deployment | Nix (`modules/cli/apm.nix`) |
| Project-specific `CLAUDE.md` | Per-repo (manual) |
| Project-specific agent context | Per-repo `apm.yml` referencing this package |

## Using in a project

To pull these primitives into any project repo:

```yaml
# apm.yml at project root
name: my-project
dependencies:
  apm:
    - /Users/matkins1/code/dotfiles/agent-config
```

Then `apm install` in that project deploys the skills and agents locally too.
