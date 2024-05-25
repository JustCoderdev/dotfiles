# :! cp ./.zshrc ~


# PROMPT=$'%F{white}%~ %B%F{blue}>%f%b '
PROMPT=$'%F{grey}%~ %B%F{white}$%f%b '



##  Options  ##
setopt   HIST_SAVE_NO_DUPS    # don't save duplicates to history
unsetopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt   AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt   COMPLETE_IN_WORD     # Complete from both ends of a word.



##  Completition  ##
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

zstyle ':completion:*' menu select



##  Bindings  ##
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -r '^K'



# more files
source ~/.config/zsh/aliases
