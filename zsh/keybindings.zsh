#> justcoderdev zsh completitions

# Keybindings

## move in history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^j' vi-down-line-or-history

# bindkey -r '^K'
# bindkey -r '^D' # use to delete hole line

## move text area
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^l' vi-forward-char

bindkey -M menuselect '^d' vi-forward-blank-word  # move to next group
bindkey -M menuselect '^u' vi-backward-blank-word # move to prev group

# bindkey -M menuselect '0' beginning-of-buffer-or-history # move to leftmost column
# bindkey -M menuselect '$' end-of-buffer-or-history       # move to rightmost column

bindkey -M menuselect '^u' undo
# bindkey -M menuselect '\t' accept-line
# bindkey -M menuselect '^c' send-break

