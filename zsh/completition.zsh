# justcoderdev zsh completitions

##  Options  ##
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "~/.config/zsh/.cache/.zcompcache"
zstyle ':completion:*' menu select


##  Keybindings  ##
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^l' vi-forward-char

bindkey -M menuselect '^d' vi-forward-blank-word  # move to next group
bindkey -M menuselect '^u' vi-backward-blank-word # move to prev group

# bindkey -M menuselect '0' beginning-of-buffer-or-history # move to leftmost column
# bindkey -M menuselect '$' end-of-buffer-or-history       # move to rightmost column

bindkey -M menuselect '^u' undo
# bindkey -M menuselect '\t' accept-line
# bindkey -M menuselect '^c' send-break


##  Theme  ##
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*' group-name ''
