## -*- mode: makefile-gmake; -*-

.PHONY: all
all: osx-config alacritty tmux git karabiner ssh vim zsh homebrew tfenv

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: osx-config
osx-config: ## Setup global system (OS) configurations
	./osx-config.sh

.PHONY: alacritty
alacritty: ## Setup Alacritty configuration
	mkdir -p ${HOME}/.config/alacritty
	ln -vsf ${PWD}/.config/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

.PHONY: tmux
tmux: ## Setup tmux configuration
	ln -vsf ${PWD}/.tmux.conf ${HOME}

.PHONY: git
git: ## Setup Git configuration
	ln -vsf ${PWD}/.gitconfig ${HOME}
	ln -vsf ${PWD}/.gitconfig-bebit ${HOME}
	mkdir -p ${HOME}/.config/git
	ln -vsf ${PWD}/.config/git/ignore ${HOME}/.config/git/ignore

.PHONY: karabiner
karabiner: ## Setup Karabiner configuration
	mkdir -p ${HOME}/.config/karabiner
	ln -vsf ${PWD}/.config/karabiner/karabiner.json ${HOME}/.config/karabiner/karabiner.json

.PHONY: ssh
ssh: ## Setup ssh configuration
	ln -vsf ${PWD}/.ssh/conf.d ${HOME}/.ssh/
	ln -vsf ${PWD}/.ssh/config ${HOME}/.ssh/

.PHONY: vim
vim: ## Setup Vim configuration
	ln -vsf ${PWD}/.vimrc ${HOME}
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: zsh
zsh: ## Setup Zsh configuration
	ln -vsf ${PWD}/.zshrc ${HOME}

.PHONY: homebrew
homebrew: ## Setup Homebrew configuration
	ln -vsf ${PWD}/Brewfile ${HOME}
	brew bundle
	brew autoupdate --start --upgrade --cleanup --enable-notification

.PHONY: tfenv
tfenv: ## Setup Terraform-env
	tfenv install latest
