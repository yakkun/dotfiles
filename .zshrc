# General config
bindkey -e # emacs
export LANGUAGE="ja_JP.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export EDITOR=vim
export CLICOLOR=1

# General zsh config
setopt correct           # コマンドのスペルチェック
setopt auto_list         # 補完候補が複数ある時に、一覧表示
setopt auto_menu         # 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt no_list_types     # auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt auto_param_slash  # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs         # ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt auto_param_keys   # 自動補完される余分なカンマなどを適宜削除してスムーズに入力できるように
setopt rc_expand_param   # {}をbash ライクに展開
setopt list_packed       # 補完候補を詰めて表示
setopt print_eight_bit   # 8 ビット目を通すようになり、日本語のファイル名を表示可能
LISTMAX=0                # 補完は画面表示を超える時にだけ聞く

# General zsh config (histories)
setopt extended_history   # 履歴ファイルに時刻を記録
setopt hist_no_store      # history コマンドをヒストリにいれない
setopt hist_reduce_blanks # 履歴から冗長な空白を除く
setopt hist_no_functions  # 関数定義をヒストリに入れない

# ===== zplug =====
# Install and load
if [[ ! -f ~/.zplug/init.zsh ]]; then
  printf "[WARN] zplug is needed by .zshrc but seems NOT installed, install now? [y/N]: "
  if read -q; then
    echo
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  fi
fi
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:"zplug --self-manage"
# Theme
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
# Vanilli.sh (lightweight start point of shell configuration)
zplug "yous/vanilli.sh"
# ehnacd
zplug "b4b4r07/enhancd", use:init.sh
export ENHANCD_FILTER=fzy:fzf:peco
export ENHANCD_DISABLE_DOT=1
#export ENHANCD_DISABLE_HYPHEN=1
export ENHANCD_DISABLE_HOME=1
# z.sh
zplug "rupa/z", use:"*.sh"
# Syntax highlighter
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# History substring search
zplug "zsh-users/zsh-history-substring-search", defer:3
if zplug check "zsh-users/zsh-history-substring-search"; then
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
fi
# Suggestions like FISH shell
zplug "zsh-users/zsh-autosuggestions"
# Auto completions
zplug "zsh-users/zsh-completions"
# Use fzy for zsh
zplug "aperezdc/zsh-fzy"
bindkey '^R' fzy-history-widget
# Load .env file automatically
zplug "plugins/dotenv", from:oh-my-zsh
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "[zplug:NOTICE] some plugins are seems NOT installed, install now? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi
# Load all
zplug load
# ===== /zplug =====

# Misc config
export GOPATH=$HOME/go
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH
export PATH=$PATH:/usr/local/sbin:$HOME/.nodebrew/current/bin:$GOPATH/bin
export HOMEBREW_NO_AUTO_UPDATE="1"

# Misc aliases
alias ls='ls --color -F'
alias la='ls -a'
alias ll='ls -alG'
alias vi='vim'
alias diff='colordiff -u'
alias grep='grep --color'
alias less='less -NR'
alias dc='docker-compose'

# ===== Functions =====
# Ctrl-g: Cd-to-ghq-repository
function cd-fzy-ghqlist() {
  local GHQ_ROOT=$(ghq root)
  local REPO=$(ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' | fzy)
  if [ -n "${REPO}" ]; then
    BUFFER="cd ${GHQ_ROOT}/${REPO}"
  fi
  zle accept-line
}
zle -N cd-fzy-ghqlist
bindkey '^G' cd-fzy-ghqlist

# command fcd (to cd current open folder on Finder)
function fcd() {
  cd "`osascript -l JavaScript -e \"decodeURIComponent(Application('Finder').windows[0].target().url().replace('file://', '')).replace(/\\"/g, '\\\"');\"`" && pwd
}

# hub
type hub >/dev/null && eval "$(hub alias -s)"
# direnv
type direnv >/dev/null && eval "$(direnv hook zsh)"
# rbenv
type rbenv >/dev/null && eval "$(rbenv init - zsh)"
# pyenv
type pyenv >/dev/null && eval "$(pyenv init -)"
# pyenv-virtualenv
type pyenv-virtualenv-init >/dev/null && eval "$(pyenv virtualenv-init -)"
# jenv
type jenv >/dev/null && eval "$(jenv init -)"

# tmux
[[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]] && tmux
