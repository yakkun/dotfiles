# Init Homebrew
if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Init Envs
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export EDITOR=nvim
export GPG_TTY=$(tty)

# Zsh options
# ref: http://zsh.sourceforge.net/Doc/Release/Options.html
#
# Uniq PATHs
typeset -U path PATH
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

# ===== sheldon =====
# Load plugins via sheldon (https://sheldon.cli.rs/)
if type sheldon >/dev/null; then
  eval "$(sheldon source)"
fi

# Configure for plugins
# history-substring-search keybindings
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
# ===== /sheldon =====

# fzf
type fzf >/dev/null && source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 20% --tmux bottom,20% --layout reverse --border top'
# Use fd for fzf (faster than find)
if type fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# bat
if type bat >/dev/null; then
  alias bat='nocorrect bat'
  alias cat=bat
  export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# Envs
export LESS='-R'
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
type brew >/dev/null && export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$(brew --prefix)/opt/grep/libexec/gnubin:$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"

# Aliases
alias ls='eza'
alias ll='eza -l -a --git'
alias tree='eza -T --group-directories-first --level 2'
type nvim >/dev/null && alias vi='nvim' && alias vim='nvim'
alias grep='grep --color'
type docker >/dev/null && alias dc='docker compose'
alias flutter='fvm flutter'

# Completion for Dart
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true

# ===== Functions =====
# Claude Code with split terminal (80%/20%)
cc() {
  if [[ -z "$TMUX" ]]; then
    echo "tmux session required"
    return 1
  fi
  tmux split-window -v -l 20%
  tmux select-pane -U
  claude "$@"
}
# Change directory with ghq list (Ctrl-G)
function cd-fzf-ghqlist() {
  local GHQ_ROOT=$(ghq root)
  local REPO=$(ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' | fzf)
  if [ -n "${REPO}" ]; then
    BUFFER="cd ${GHQ_ROOT}/${REPO}"
  fi
  zle accept-line
}
zle -N cd-fzf-ghqlist && bindkey '^G' cd-fzf-ghqlist

# Change directory to current open in Finder
cdf() {
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}
# ===== /Functions =====

# mise (runtime version manager)
type mise >/dev/null && eval "$(mise activate zsh)"

# zoxide (smarter cd)
type zoxide >/dev/null && eval "$(zoxide init zsh)"

# Starship prompt
type starship >/dev/null && eval "$(starship init zsh)"

# Auto start tmux
if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$INSIDE_EMACS" && "$TERM_PROGRAM" != "vscode" && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
  tmux attach >/dev/null 2>&1 || tmux new
fi
