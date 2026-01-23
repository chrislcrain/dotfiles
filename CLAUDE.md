# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed by [chezmoi](https://chezmoi.io) for cross-platform development environment configuration. It supports macOS (darwin), Ubuntu Linux, and Coder workspace environments with platform-specific bootstrap scripts.

## Chezmoi Workflow

### Common Commands

```bash
# Apply dotfiles to the system
chezmoi apply

# Edit a dotfile (opens in $EDITOR, tracks changes)
chezmoi edit ~/.zshrc

# See what would change without applying
chezmoi diff

# Update dotfiles from source directory
chezmoi update

# Re-run bootstrap script
chezmoi init --apply

# Add a new file to be managed
chezmoi add ~/.gitconfig
```

### File Naming Conventions

Chezmoi uses special prefixes for file names in the source directory:
- `dot_` → `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `.tmpl` suffix → Template file (uses Go text/template syntax)
- `run_once_` → Script that runs once during `chezmoi init`

### Platform Detection in Templates

Templates can use chezmoi variables for platform-specific configuration:
- `{{ if eq .chezmoi.os "darwin" }}` - macOS specific
- `{{ if eq .chezmoi.os "linux" }}` - Linux specific
- `{{ if eq .chezmoi.username "coder" }}` - Coder workspace specific

## Repository Structure

### Bootstrap Scripts (`/bin`)

Three platform-specific bootstrap scripts handle initial setup:

1. **bootstrap_darwin.sh** - macOS setup using Homebrew
   - Installs packages from `~/.config/brew/Brewfile`
   - Sets up pyenv, poetry, pipx tooling
   - Configures Neovim with Lazy plugin manager
   - Installs Coder CLI, fzf, and tfenv

2. **bootstrap_ubuntu.sh** - Ubuntu Linux setup using apt
   - Installs system packages via apt
   - Adds HashiCorp, Microsoft (PowerShell), and 1Password repos
   - Installs Azure CLI, Node.js, kubectl
   - System-level installations (requires sudo)

3. **bootstrap_coder.sh** - Coder workspace setup (user-local)
   - User-local installations only (no system packages)
   - Uses pipx for Python tools (azure-cli, poetry, debugpy)
   - Installs PowerShell, Node.js to `~/.local`
   - Uses tfenv for Terraform version management

### External Dependencies (`.chezmoiexternal.toml.tmpl`)

Chezmoi automatically manages external resources:
- Oh My Zsh and plugins (zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions)
- Powerlevel10k theme
- fzf (fuzzy finder)
- Neovim (platform-specific binaries)
- tree-sitter CLI
- tfenv (Terraform version manager)

These are auto-installed/updated based on `refreshPeriod` settings.

### Configuration Directories (`/dot_config`)

- **brew/** - Homebrew bundle file (macOS only)
- **direnv/** - Environment switcher configuration
- **git/** - Git configuration
- **nvim/** - Neovim configuration (Lua-based)
- **shell/** - Common shell configurations sourced by `.profile`
- **wezterm/** - WezTerm terminal emulator configuration

### Neovim Configuration (`/dot_config/nvim`)

Neovim is configured with:
- **Lazy.nvim** plugin manager (`lua/lazy.lua`)
- LSP support via Mason (`lua/plugins/lsp/`)
- Plugin configurations in `lua/plugins/` (codecompanion, treesitter, debugging, copilot, etc.)
- Core settings in `lua/core/` (keymaps, options, autocmds)
- Python host: uses pyenv shims (`~/.pyenv/shims/python3`)

First-time setup runs: `nvim --headless "+Lazy! sync" +qa`

### Shell Configuration

- **ZSH** is the default shell
- **Oh My Zsh** framework with custom plugin directory: `~/.config/ohmyzsh/.zsh_custom`
- **Powerlevel10k** theme (configured in `.p10k.zsh`)
- **Plugins**: git, poetry, zsh-autosuggestions, zsh-completions, direnv, zsh-syntax-highlighting
- **fzf** for fuzzy finding with custom key bindings
- **direnv** for per-directory environment management

Environment paths are extended in `.zshrc.tmpl` with:
- `~/.local/bin` for user binaries
- Platform-specific paths (PostgreSQL on macOS, Mason LSP servers, etc.)

## Development Tools

### Language Tooling
- **Python**: pyenv for version management, pipx for isolated CLI tools, poetry for dependency management
- **Node.js**: Installed via Homebrew (macOS), NodeSource (Ubuntu), or n (Coder)
- **Terraform**: Managed via tfenv for version switching
- **PowerShell**: Cross-platform scripting support

### Essential CLI Tools
- **ripgrep** (rg) - Fast text search
- **fzf** - Fuzzy finder for files/history
- **gh** - GitHub CLI
- **direnv** - Directory-specific environment variables
- **luarocks** - Lua package manager (for Neovim plugins)
- **kubectl** - Kubernetes CLI
- **azure-cli** - Azure cloud management
- **1password-cli** - Secrets management (macOS/Ubuntu)

## Modifying the Configuration

### Adding a New Dotfile

```bash
# Add file to chezmoi management
chezmoi add ~/.newconfig

# The file will appear in the source directory as dot_newconfig
# Edit it directly or use: chezmoi edit ~/.newconfig
```

### Adding Platform-Specific Configuration

For platform-specific configs, add `.tmpl` extension and use conditionals:

```bash
# In dot_config/example/config.toml.tmpl
{{ if eq .chezmoi.os "darwin" }}
macos_option = true
{{ else if eq .chezmoi.os "linux" }}
linux_option = true
{{ end }}
```

### Adding New External Dependencies

Edit `.chezmoiexternal.toml.tmpl` to add new external resources (Git repos, archives, files).

### Updating Bootstrap Scripts

When adding new system tools:
- macOS: Add to `dot_config/brew/Brewfile` and `bin/bootstrap_darwin.sh`
- Ubuntu: Add to `bin/bootstrap_ubuntu.sh` (system install)
- Coder: Add to `bin/bootstrap_coder.sh` (user-local install)

## Testing Changes

```bash
# Dry-run to see what would change
chezmoi diff

# Apply changes and verify
chezmoi apply

# For bootstrap script changes, test with:
chezmoi init --apply
```
