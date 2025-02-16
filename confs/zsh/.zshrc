# Options
setopt   AUTO_LIST          # Automatically list choices on ambiguous completion
setopt   AUTO_MENU          # Start completition by pressing the tab key repeatedly

setopt   AUTO_PARAM_SLASH   # Add a trailing slash instead of a space
setopt   AUTO_REMOVE_SLASH  # Remove trailing slash after delimiter

setopt   COMPLETE_ALIASES   # Complete aliases
setopt   COMPLETE_IN_WORD   # Complete from both ends of a word

setopt   LIST_PACKED        # Make completition list smaller
setopt   LIST_ROWS_FIRST    # Lay out the matches in completion lists sorted horizontally

unsetopt MENU_COMPLETE      # Automatically highlight first element of completion menu

## history
unsetopt HIST_SAVE_NO_DUPS  # Don't save duplicates to history
unsetopt SHARE_HISTORY      # Share history with all zsh sessions


# Completition

## Pre load completition (?)
fpath=("${DOT_FILES}/confs/zsh/ccomp" ${fpath})
autoload -U compinit; compinit
_comp_options+=(globdots)
zmodload zsh/complist

## Options
zstyle ':completion:*' cache-path "/home/${USER}/zsh/.zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select

## Style
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*' group-name ''


# Source the rest...
source "${DOT_FILES}/confs/zsh/prompt.zsh"
source "${DOT_FILES}/confs/zsh/aliases.zsh"
source "${DOT_FILES}/confs/zsh/pathers.zsh"

