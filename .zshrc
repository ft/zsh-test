# Here is an example zshrc file to go with the search paths being set
# for local operation. You probably want to use this to setup any
# interactive tests you might have in mind.

# Load the Line Editor:
zmodload zsh/parameter
zmodload zsh/zle
zmodload zsh/zleparameter

# Turn off the terminal's flow control feature:
setopt no_flow_control

# Application mode while zle is active.
function zle-line-init() {
    emulate -L zsh
    printf '%s' ${terminfo[smkx]}
}

function zle-line-finish() {
    emulate -L zsh
    printf '%s' ${terminfo[rmkx]}
}

zle -N zle-line-init
zle -N zle-line-finish

# Load the completion system:
zmodload zsh/complete
zmodload zsh/complist

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Force emacs keybindings and add some bindings:
bindkey -e
bindkey '^i' complete-word
bindkey -M menuselect '^s' history-incremental-search-forward
bindkey -M menuselect '^r' history-incremental-search-backward

# A history for testing shells? Why not.
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
HISTSIZE=256
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory.test"
SAVEHIST=128

# And a dirstack as well:
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
DIRSTACKSIZE=30
