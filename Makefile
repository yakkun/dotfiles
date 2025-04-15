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

.PHONY: vim
vim: ## Setup Vim configuration
	ln -vsf ${PWD}/.vimrc ${HOME}/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: zsh
zsh: ## Setup Zsh configuration
	ln -vsf ${PWD}/.zshrc ${HOME}/

.PHONY: homebrew
homebrew: ## Setup Homebrew configuration
	ln -vsf ${PWD}/Brewfile ${HOME}/
	brew bundle
	brew autoupdate start --cleanup

.PHONY: diff-highlight
diff-highlight: ## Setup diff-highlight
	ln -sf `brew --prefix`/share/git-core/contrib/diff-highlight/diff-highlight `brew --prefix`/bin/

.PHONY: flutter
flutter: ## Setup Flutter dev env
	fvm install stable
