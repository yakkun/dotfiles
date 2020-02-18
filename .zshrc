# Init Envs
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export EDITOR=vim

# Zsh options
# ref: http://zsh.sourceforge.net/Doc/Release/Options.html
#
# Key bindings
bindkey -e # Emacs mode
# Changing Directories
setopt auto_cd           # Perform the cd command to that directory if a command can't be executed
setopt auto_pushd        # Make the cd command to push the old directory onto the directory stack
setopt pushd_ignore_dups # Don’t push multiple copies of the same directory onto the directory stack
# Completion
setopt always_to_end     # The cursor is moved to the end of the word when a completion is performed
unsetopt list_beep       # Don't beep on an ambiguous completion
setopt list_packed       # Smaller the completion list
LISTMAX=0                # Ask me with lots of completions list only-if over the window
# Expansion and Globbing
setopt magic_equal_subst # Performed filenames on commands arguments
setopt mark_dirs         # Add a trailing '/' to all directory names
setopt rc_expand_param   # Expand braces like bash ($xx=(a b c), ‘foo${xx}bar’ -> ‘fooabar foobbar foocbar’)
# Input/Output
setopt correct         # Try to correct the spelling of commands
unsetopt flow_control  # Disable output flow control via start/stop chars (^S/^Q)
setopt print_eight_bit # Print eight bit characters (Japanese) literally in completion lists
# History
[ -z "$HISTFILE" ] && HISTFILE=${HOME}/.zsh_history # Filename to save
HISTSIZE=10000            # Lines saving on memory
SAVEHIST=30000            # Lines saving on $HISTFILE
setopt hist_find_no_dups  # Remove duplicated commands from history searches
setopt hist_verify        # Confirm before exexuting commands from hisory
setopt inc_append_history # Log commands a.s.a.p they are enteterd
setopt extended_history   # With timestamp
setopt hist_reduce_blanks # Remove superfluous blanks
setopt hist_no_functions  # Remove function definitions

# ===== zplug =====
# Install and load
if [[ ! -f ~/.zplug/init.zsh ]]; then
  printf "[WARN] zplug is needed by .zshrc but seems NOT installed, install now? [y/N]: "
  if read -q; then
    echo && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  fi
fi
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "b4b4r07/enhancd", use:init.sh
zplug "rupa/z", use:"*.sh"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "aperezdc/zsh-fzy"
if ! zplug check; then
  printf "[zplug:NOTICE] some plugins are seems NOT installed, install now? [y/N]: "
  if read -q; then
    echo && zplug install
  fi
fi
zplug load
# Configure for plugins
if zplug check "b4b4r07/enhancd"; then
  export ENHANCD_FILTER=fzy:fzf:peco
  export ENHANCD_DISABLE_DOT=1
  #export ENHANCD_DISABLE_HYPHEN=1
  export ENHANCD_DISABLE_HOME=1
fi
if zplug check "zsh-users/zsh-history-substring-search"; then
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
fi
if zplug check "aperezdc/zsh-fzy"; then
  bindkey '^R' fzy-history-widget
fi
# ===== /zplug =====

# Envs
export LESS='-NR'
type brew >/dev/null && export PATH=/usr/local/sbin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH
type nodebrew >/dev/null && export PATH=$PATH:$HOME/.nodebrew/current/bin
type rvm >/dev/null && export PATH=$PATH:$HOME/.rvm/bin
type go >/dev/null && export GOPATH=$HOME/go && export PATH=$PATH:$GOPATH/bin

# Aliases
alias ls='ls --color -F'
alias ll='ls -alG'
type vim >/dev/null && alias vi='vim'
type colordiff >/dev/null && alias diff='colordiff -u'
alias grep='grep --color'
type docker-compose >/dev/null && alias dc='docker-compose'

# ===== Functions =====
# Change directory with ghq list (Ctrl-G)
function cd-fzy-ghqlist() {
  local GHQ_ROOT=$(ghq root)
  local REPO=$(ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' | fzy)
  if [ -n "${REPO}" ]; then
    BUFFER="cd ${GHQ_ROOT}/${REPO}"
  fi
  zle accept-line
}
zle -N cd-fzy-ghqlist && bindkey '^G' cd-fzy-ghqlist
# ===== /Functions =====

# Init applications
type hub >/dev/null && eval "$(hub alias -s)"
type direnv >/dev/null && eval "$(direnv hook zsh)"
type rbenv >/dev/null && eval "$(rbenv init - zsh)"

# Auto start tmux
if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$INSIDE_EMACS" && "$TERM_PROGRAM" != "vscode" ]]; then
  tmux attach >/dev/null 2>&1 || tmux new
fi
