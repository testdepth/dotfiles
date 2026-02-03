# AGENTS.md

Personal dotfiles repository - AI coding guidelines.

## Project Overview

Dotfiles for reproducible development environment setup using Nix, devenv, and home-manager.

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `modules/` | Modular Nix configurations |
| `hosts/` | Per-machine configurations |
| `scripts/` | Helper scripts |
| `.claude/` | Claude Code settings |

**Always read the relevant module before making changes.**

## Development Environment

Nix + devenv for reproducible environments:

```bash
cd ~/.dotfiles && direnv allow   # Auto-loads devenv
```

## Code Style

- Prefer clean, simple functional code
- **No comments** unless logic is genuinely complex and non-obvious
- Use type hints (Python) and strict mode (TypeScript)
- Research existing patterns before implementing new ones

## Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) format:

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `ci`, `build`, `chore`, `revert`

```bash
feat: add ghostty terminal config
fix: correct fish shell detection
```

## Branch Naming

```
feature/description
fix/description
```

---

## Python Guidelines

### Core Principles

1. **Type Safety** - Use type hints everywhere
2. **Testing** - Write pytest tests for all code
3. **Async First** - Use async/await for I/O operations
4. **Data Validation** - Use Pydantic models

### Code Style

- **Indentation**: 4 spaces
- **Line length**: 88 characters (Black style)
- **Naming**: `snake_case` for functions/variables, `PascalCase` for classes

### Modern Type Syntax (Python 3.10+)

```python
def process_data(
    items: list[dict[str, Any]],
    max_count: int | None = None,
) -> list[str]:
    pass
```

### Testing with pytest

```python
import pytest

class TestUserService:
    @pytest.fixture
    def sample_user(self):
        return User(name="John", email="john@example.com")
    
    def test_create_user(self, sample_user):
        result = create_user(sample_user)
        assert result.id is not None
```

### Dependency Management

Use **uv** for fast Python package management:

```bash
uv add package-name
uv sync
```

---

## TypeScript/Frontend Guidelines

### Core Principles

1. **Type Safety** - Strict TypeScript, never use `any`
2. **Testing** - Vitest/Jest tests for all components
3. **Component Composition** - Small, reusable components
4. **Declarative** - What, not how

### Strict Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true
  }
}
```

### Component Pattern

```typescript
import type { FC, ReactNode } from 'react';

interface ButtonProps {
  children: ReactNode;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export const Button: FC<ButtonProps> = ({
  children,
  onClick,
  variant = 'primary',
}) => {
  return (
    <button onClick={onClick} className={`btn btn-${variant}`}>
      {children}
    </button>
  );
};
```

### Testing

```typescript
import { render, screen } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button onClick={() => {}}>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });
});
```

---

## GitHub Actions Guidelines

### Workflow Structure

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@v20
      - uses: DeterminateSystems/magic-nix-cache-action@v13
      - name: Run tests
        run: nix develop --impure --command bash -c 'test-command'
```

### Conventional Commits

- `feat:` → Minor version bump
- `fix:` → Patch version bump
- `BREAKING CHANGE:` → Major version bump

### Security Best Practices

1. **Never log secrets** - Mask in outputs
2. **Minimal permissions** - Least privilege
3. **Pin actions** - Use SHA, not tags
4. **Rotate regularly** - Update secrets periodically

---

## Shell Script Guidelines

### Bash Best Practices

```bash
#!/usr/bin/env bash
set -euo pipefail

# Use $HOME instead of hardcoded paths
# Use $USER instead of hardcoded usernames
# Quote variables: "$VAR"
# Check command existence: command -v foo >/dev/null
```

### Error Handling

```bash
if ! command -v git &> /dev/null; then
    echo "Error: git is required"
    exit 1
fi
```

---

## Nix/devenv Guidelines

### Standard devenv.nix Pattern

```nix
{ pkgs, ... }:
{
  languages.python.enable = true;
  
  packages = with pkgs; [
    git
    ripgrep
  ];
  
  scripts.hello.exec = "echo 'Hello!'";
  
  enterShell = ''
    echo "Development environment loaded"
  '';
}
```

### Standard .envrc

```bash
if ! has nix_direnv_version || ! nix_direnv_version 3.1.0; then
  source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.1.0/direnvrc" "sha256-..."
fi
use flake
```

---

## Best Practices Summary

1. **Always test changes** before marking complete
2. **Use conventional commits** for clear history
3. **Keep changes minimal** - touch only what's necessary
4. **Document complex logic** - but prefer self-documenting code
5. **Run linters** before committing
