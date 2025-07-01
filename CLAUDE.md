# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environment setup. It uses GNU Make for orchestration and Homebrew for package management.

## Key Commands

### Initial Setup
```bash
make         # Run all setup tasks (creates symlinks for all configurations)
make help    # Display available make targets
```

### Individual Configuration Setup
```bash
make alacritty      # Setup Alacritty terminal configuration
make tmux           # Setup tmux configuration
make git            # Setup Git configuration (includes gitconfig, tigrc)
make ssh            # Setup SSH configuration
make vim            # Setup Vim configuration (includes vim-plug installation)
make zsh            # Setup Zsh configuration
make homebrew       # Setup Homebrew and install all packages from Brewfile
make diff-highlight # Setup diff-highlight for Git
make flutter        # Setup Flutter development environment with fvm
make claude-code    # Setup Claude Code configuration (CLAUDE.md and settings.json)
```

### macOS System Configuration
```bash
./scripts/osx-config.sh  # Configure macOS system preferences (keyboard, trackpad, Finder, etc.)
```

## Architecture

### Directory Structure
- **Root dotfiles**: `.gitconfig`, `.tmux.conf`, `.vimrc`, `.zshrc`, `.tigrc` - symlinked to home directory
- **`.config/`**: XDG config directory structure for applications like Alacritty
- **`.ssh/`**: SSH configuration files and config.d directory
- **`claude/`**: Claude Code specific configurations (CLAUDE.md for conversation rules, settings.json)
- **`scripts/`**: Shell scripts for system configuration
- **`Brewfile`**: Homebrew bundle file defining all packages to install

### Key Configuration Details

1. **Git Setup**: Includes main gitconfig, work-specific gitconfig (gitconfig-yamareco), global gitignore, and tigrc
2. **Shell Environment**: Zsh with custom configurations, supports both Intel and Apple Silicon Macs (detects architecture for Homebrew)
3. **Development Tools**: Includes configurations for multiple languages (Go, Node.js, PHP, Python, Flutter) via anyenv
4. **Claude Code Integration**: Symlinks local claude/ directory contents to ~/.claude/ for global Claude preferences

### Symlink Strategy

All configurations use symlinks (`ln -vsf`) from the repository to their expected locations in the home directory. This allows version control of configurations while keeping them in their standard locations.

## Development Workflow

When modifying configurations:
1. Edit files in this repository (not in their symlinked locations)
2. Test changes locally
3. Commit changes to track configuration evolution

## Important Notes

- The repository includes both personal (`.gitconfig-yamareco`) and general Git configurations
- Homebrew autoupdate is enabled during setup
- macOS system preferences script (`osx-config.sh`) makes extensive system modifications
- Claude Code preferences in `claude/CLAUDE.md` specify Japanese language for user interactions while keeping code/commits in English