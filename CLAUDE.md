# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS development environment. Uses GNU Make for orchestration and Homebrew for package management.

## Commands

```bash
make                # Display available make targets
make ghostty        # Setup Ghostty terminal config
make tmux           # Setup tmux config
make git            # Setup Git config (gitconfig, tigrc, global ignore)
make ssh            # Setup SSH config with conf.d includes
make nvim           # Setup Neovim (LazyVim) config
make zsh            # Setup Zsh, sheldon plugins, starship prompt
make homebrew       # Symlink Brewfile, run brew bundle, enable autoupdate
make flutter        # Install stable Flutter via fvm
make claude-code    # Setup Claude Code (CLAUDE.md, settings, statusline, commands, skills, hooks)
./scripts/osx-config.sh  # Configure macOS system preferences
```

## Architecture

### Symlink Strategy

All configurations use `ln -vsf` (files) or `ln -vsfn` (directories) to symlink from this repository to their expected locations (`~/.gitconfig`, `~/.config/`, `~/.ssh/`, etc.). Edit files here, not at symlinked destinations.

### Key Directories

- **Root**: Dotfiles symlinked directly to home (`.gitconfig`, `.tmux.conf`, `.zshrc`, `.tigrc`)
- **`.config/`**: XDG config (ghostty, nvim/LazyVim, sheldon, starship, git ignore)
- **`.ssh/`**: SSH config with modular `conf.d/` includes (+ `conf.d/confidential/` gitignored for private hosts)
- **`claude/`**: Claude Code configurations → symlinked to `~/.claude/`
  - `CLAUDE.md`: Global user instructions (conversation in Japanese, code in English)
  - `settings.json`: Permissions, hooks, statusline, plugins (context7, serena, code-review, swift-lsp)
  - `commands/`: Custom slash commands (cmux-open-pr, cmux-open-repo)
  - `skills/`: Custom skills
  - `hooks/`: Notification hooks (Stop → desktop/cmux notification, PostToolUse/Task → cmux notification)
  - `statusline.sh`: Displays directory, git branch, model, context usage, tokens, rate limits, cost
- **`scripts/`**: `osx-config.sh` (macOS preferences), `git-monitor.sh` (cockpit git status pane)

### Git Configuration

- Multiple identities: main `.gitconfig` with conditional include for `~/ghq/github.com/yamareco/**` → `.gitconfig-yamareco`
- GPG commit signing is enabled (`commit.gpgsign = true`) — never bypass with `--no-gpg-sign`
- `git-secrets` is configured to scan for AWS credentials on commit
- Uses `delta` as pager with line numbers
- `push.autoSetupRemote = true` and `push.default = current`

### Shell Environment

- Zsh auto-detects Intel vs Apple Silicon for correct Homebrew paths
- Plugin manager: sheldon (with zsh-defer for lazy loading)
- Prompt: starship; Runtime manager: mise; Smart cd: zoxide
- `cockpit` shell function: creates a tmux multi-pane Claude Code workspace (N Claude panes + terminal + git-monitor)
- Ctrl-G: fzf-powered directory switching via `ghq list`

### Notification System

Hooks in `claude/hooks/` send notifications via cmux (if available) or macOS `osascript`. This integrates with the cockpit workflow where multiple Claude instances run in tmux panes.