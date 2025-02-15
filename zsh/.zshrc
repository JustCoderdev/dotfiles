# :! cp ./.zshrc ~

# Options

## Vim motions
# bindkey -v
# export KEYTIMEOUT=1

## Completition
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

# Pre load completition (?)
fpath=("${DOT_FILES}/zsh/ccomp" ${fpath})
autoload -U compinit; compinit
_comp_options+=(globdots)
zmodload zsh/complist

# Source the rest...
source "${DOT_FILES}/zsh/prompt.zsh"
source "${DOT_FILES}/zsh/aliases.zsh"
source "${DOT_FILES}/zsh/pathers.zsh"
source "${DOT_FILES}/zsh/keybindings.zsh"
source "${DOT_FILES}/zsh/completition.zsh"
#source "${DOT_FILES}/zsh/purification.zsh"

