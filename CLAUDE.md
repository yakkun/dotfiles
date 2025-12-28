# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS development environment. Uses GNU Make for orchestration and Homebrew for package management.

## Commands

```bash
make              # Display available make targets
make <target>     # Run specific setup (e.g., make git, make zsh)
./scripts/osx-config.sh  # Configure macOS system preferences
```

## Architecture

### Symlink Strategy

All configurations use `ln -vsf` to symlink from this repository to their expected locations (`~/.gitconfig`, `~/.config/`, `~/.ssh/`, etc.). Edit files here, not at symlinked destinations.

### Key Directories

- **Root**: Dotfiles symlinked directly to home (`.gitconfig`, `.tmux.conf`, `.vimrc`, `.zshrc`, `.tigrc`)
- **`.config/`**: XDG config (alacritty, git ignore)
- **`.ssh/`**: SSH config with modular `conf.d/` includes
- **`claude/`**: Claude Code configurations → symlinked to `~/.claude/`
  - `commands/`: Custom slash commands (`/git-commit`, `/gh-open-pr`)
  - `statusline.sh`: Displays current directory, git branch, and usage via `ccusage`
- **`scripts/`**: System configuration scripts

### Git Configuration

Supports multiple identities: main `.gitconfig` with conditional include for work-specific `.gitconfig-yamareco`.

### Shell Environment

Zsh configuration auto-detects Intel vs Apple Silicon for correct Homebrew paths.