# :! cp ./.zshrc ~

##  Options  ##

# vim motions
# bindkey -v
# export KEYTIMEOUT=1

# completition
setopt   AUTO_LIST            # Automatically list choices on ambiguous completion
setopt   AUTO_MENU			  # Start completition by pressing the tab key repeatedly

setopt   AUTO_PARAM_SLASH	  # Add a trailing slash instead of a space
setopt   AUTO_REMOVE_SLASH	  # Remove trailing slash after delimiter

setopt   COMPLETE_ALIASES	  # Complete aliases
setopt   COMPLETE_IN_WORD     # Complete from both ends of a word

setopt   LIST_PACKED 		  # Make completition list smaller
setopt   LIST_ROWS_FIRST	  # Lay out the matches in completion lists sorted horizontally

unsetopt MENU_COMPLETE        # Automatically highlight first element of completion menu

# history
setopt   SHARE_HISTORY    	  # Share history with all zsh sessions
setopt   HIST_SAVE_NO_DUPS    # Don't save duplicates to history


##  Completition  ##
autoload -U compinit; compinit
_comp_options+=(globdots)
zmodload zsh/complist


##  Bindings  ##
# bindkey -r '^K'
# bindkey -r '^D' # use to delete hole line


# more files
# source ~/.config/zsh/purification.zsh
source ~/.config/zsh/cursor.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/completition.zsh

