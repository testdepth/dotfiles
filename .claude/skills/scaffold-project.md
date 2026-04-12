# scaffold-project

Use this skill when the user wants to scaffold a new project, set up a repository with a fullstack monorepo structure, or create a new project from template.

<command-name>scaffold-project</command-name>

## Instructions

You are a project scaffolding agent. Your job is to create a new project structure based on user requirements, using patterns from a proven fullstack-nix template.

### Template Reference Structure

The template follows this pattern (adapt based on user's tech choices):

```
project-root/
├── flake.nix                 # Root flake - aggregates all packages
├── flake.lock
├── devenv.nix                # Root dev environment (hivemind processes)
├── .envrc                    # direnv: use flake . --impure
├── README.md
├── LICENSE
│
├── frontend/                  # Frontend application
│   ├── flake.nix
│   ├── devenv.nix
│   ├── nix/
│   │   ├── packages/         # Nix build definitions
│   │   └── github/workflows/ # CI workflow (Nix-defined)
│   └── README.md
│
├── backend/
│   └── {service-name}/        # Backend service(s)
│       ├── flake.nix
│       ├── devenv.nix
│       ├── nix/
│       │   ├── packages/
│       │   └── github/workflows/
│       └── README.md
│
├── infra/                     # Infrastructure as Code
│   ├── flake.nix
│   ├── devenv.nix
│   ├── config/
│   │   └── {env}.nix         # Environment configs
│   ├── modules/
│   │   └── {provider}/       # Cloud provider modules
│   └── README.md
│
└── nix/                       # Shared CI/CD utilities
    └── github/
        ├── steps.nix         # Reusable GitHub Actions steps
        └── workflows/
            └── deploy.nix
```

### Key Patterns to Follow

1. **Each subproject is self-contained** - Has its own flake.nix + devenv.nix
2. **Root aggregates subprojects** - Root flake imports and exposes all packages
3. **Process management via hivemind** - devenv.nix at root runs all services
4. **CI/CD as Nix** - GitHub Actions workflows defined in Nix using actions.nix
5. **Infrastructure as Nix** - Use Terranix for cloud-agnostic IaC

### Gathering Requirements

Before scaffolding, ask the user about:

1. **Project name** - Used for directory, package names, etc.
2. **Frontend** - Framework choice (React, Vue, Svelte, SolidJS, etc.) or "none"
3. **Backend** - Language/framework (Go, Rust, Node.js, Python, etc.) or "none"
4. **Infrastructure** - Cloud provider (AWS, GCP, Azure, Cloudflare, self-hosted) or "none"
5. **Target directory** - Where to create the project
6. **Additional services** - Database, cache, message queue, etc.
7. **Features** - SSR, static site, API-only, monolith vs microservices

### Scaffolding Process

1. **Create directory structure** based on user choices
2. **Generate root configuration files:**
   - `flake.nix` - Multi-system flake with devenv and subproject packages
   - `devenv.nix` - Process definitions for all services
   - `.envrc` - direnv configuration
   - `.gitignore` - Nix, language-specific, and editor ignores
   - `LICENSE` - Ask user for preference (MIT, Apache-2.0, etc.)

3. **Generate frontend** (if requested):
   - Package configuration (package.json, Cargo.toml, etc.)
   - Build configuration (vite.config.ts, etc.)
   - Basic app structure with placeholder content
   - `flake.nix` and `devenv.nix`
   - Nix package definitions

4. **Generate backend** (if requested):
   - Service scaffold with health endpoint
   - Build configuration
   - Lambda/serverless adapter pattern (if applicable)
   - `flake.nix` and `devenv.nix`
   - Nix package definitions

5. **Generate infrastructure** (if requested):
   - Terranix module structure
   - Provider-specific modules
   - Environment configuration templates
   - State backend setup script

6. **Generate CI/CD:**
   - Reusable steps in `nix/github/steps.nix`
   - Per-project CI workflows
   - Deploy workflow (if infra present)

7. **Write comprehensive README.md** including:
   - Project overview
   - Prerequisites (Nix, direnv)
   - Quick start instructions
   - Development workflow
   - Project structure explanation
   - Deployment instructions (if infra present)
   - Contributing guidelines

8. **Initialize git and add files**

### README Template

Generate a README following this structure:

```markdown
# {Project Name}

{Brief description}

## Prerequisites

- [Nix](https://nixos.org/) with flakes enabled
- [direnv](https://direnv.net/) (recommended)

## Quick Start

```bash
# Clone the repository
git clone {repo-url}
cd {project-name}

# Allow direnv (or run: nix develop --impure)
direnv allow

# Start all services
devenv up
```

## Development

### Project Structure

{Explain each directory}

### Running Services

{How to start frontend, backend, etc.}

### Testing

{How to run tests}

### Building

{How to build for production}

## Deployment

{If infra present, explain deployment}

## License

{License type}
```

### Important Notes

- Always use `nix-direnv` pattern: `use flake . --impure`
- Remember to `git add` new .nix files before they'll be visible to flakes
- Generate language-appropriate tooling (ESLint for JS, golangci-lint for Go, etc.)
- Include devenv processes for databases/services if requested
- Make infrastructure modules generic and composable
- Use environment variables for configuration, dotenv for local development

### After Scaffolding

1. Remind user to `git add` the .nix files
2. Instruct them to run `direnv allow`
3. Suggest running `devenv up` to verify everything works
4. Point out next steps for customization
