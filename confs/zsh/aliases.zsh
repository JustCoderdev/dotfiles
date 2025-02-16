
# Misc
alias ez="echo 'Updating zsh'; exec zsh"

unalias l
alias ls="ls --color -F"
alias la="ls -Fa"
alias ll="ls -Flah"

alias rm="rm -I"
alias cls="clear && ls"

alias cl="cls"
alias sls="ls"
alias l="ls"
alias scls="cls"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."


# Push Dir Aliases - Save Directory
alias sd='echo $(pwd) > "/home/$USER/.zsh/sd" && cat "/home/$USER/.zsh/sd"'
alias sdl='cd $(cat "/home/$USER/.zsh/sd")'


# Debug Aliases
alias fgdeb='echo -e " \033[30m[0:BLK] \033[31m[1:RED] \033[32m[2:GRN] \033[33m[3:YLW] \033[34m[4:BLU] \033[35m[5:MAG] \033[36m[6:CYN] \033[37m[7:WHT]"'
alias fgbrdeb='echo -e " \033[90m[0:GRY] \033[91m[1:RED] \033[92m[2:GRN] \033[93m[3:YLW] \033[94m[4:BLU] \033[95m[5:MAG] \033[96m[6:CYN] \033[97m[7:WHT]"'


# Programs Aliases

## make
alias mk="make"

## git
alias gs="git status"
alias gl="git log --all --color --decorate --oneline --graph"
alias gd="git diff"

alias gf="git fetch"
alias gp="git push"

alias ga="git add"
alias gc="git commit"

## nvim
alias nold="nvim -S .old_session.vim"

# wifi
alias wscan="nmcli device wifi rescan && nmcli device wifi list"
alias wconn="nmcli device wifi connect"
