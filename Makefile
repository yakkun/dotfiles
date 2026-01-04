## -*- mode: makefile-gmake; -*-

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: alacritty
alacritty: ## Setup Alacritty configuration
	mkdir -p ${HOME}/.config/alacritty
	ln -vsf ${PWD}/.config/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml

.PHONY: tmux
tmux: ## Setup tmux configuration
	ln -vsf ${PWD}/.tmux.conf ${HOME}/

.PHONY: git
git: ## Setup Git configuration
	ln -vsf ${PWD}/.gitconfig ${HOME}/
	ln -vsf ${PWD}/.gitconfig-yamareco ${HOME}/
	mkdir -p ${HOME}/.config/git
	ln -vsf ${PWD}/.config/git/ignore ${HOME}/.config/git/ignore
	ln -vsf ${PWD}/.tigrc ${HOME}/

.PHONY: ssh
ssh: ## Setup ssh configuration
	ln -vsf ${PWD}/.ssh/conf.d ${HOME}/.ssh/
	ln -vsf ${PWD}/.ssh/config ${HOME}/.ssh/

.PHONY: nvim
nvim: ## Setup Neovim configuration (LazyVim)
	mkdir -p ${HOME}/.config/nvim/lua/config ${HOME}/.config/nvim/lua/plugins
	ln -vsf ${PWD}/.config/nvim/init.lua ${HOME}/.config/nvim/
	ln -vsf ${PWD}/.config/nvim/lua/config/lazy.lua ${HOME}/.config/nvim/lua/config/
	ln -vsf ${PWD}/.config/nvim/lua/config/options.lua ${HOME}/.config/nvim/lua/config/
	ln -vsf ${PWD}/.config/nvim/lua/config/keymaps.lua ${HOME}/.config/nvim/lua/config/
	ln -vsf ${PWD}/.config/nvim/lua/config/autocmds.lua ${HOME}/.config/nvim/lua/config/
	ln -vsf ${PWD}/.config/nvim/lua/plugins/editor.lua ${HOME}/.config/nvim/lua/plugins/

.PHONY: zsh
zsh: ## Setup Zsh configuration
	ln -vsf ${PWD}/.zshrc ${HOME}/
	mkdir -p ${HOME}/.config/sheldon
	ln -vsf ${PWD}/.config/sheldon/plugins.toml ${HOME}/.config/sheldon/
	ln -vsf ${PWD}/.config/starship.toml ${HOME}/.config/

.PHONY: homebrew
homebrew: ## Setup Homebrew configuration
	ln -vsf ${PWD}/Brewfile ${HOME}/
	brew bundle
	brew autoupdate start --cleanup

.PHONY: flutter
flutter: ## Setup Flutter dev env
	fvm install stable

.PHONY: claude-code
claude-code: ## Setup Claude code
	mkdir -p ${HOME}/.claude
	ln -vsf ${PWD}/claude/CLAUDE.md ${HOME}/.claude/
	ln -vsf ${PWD}/claude/settings.json ${HOME}/.claude/
	ln -vsf ${PWD}/claude/statusline.sh ${HOME}/.claude/
	ln -vsfn ${PWD}/claude/commands ${HOME}/.claude/
