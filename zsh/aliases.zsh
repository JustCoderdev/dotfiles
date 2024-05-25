#> justcoderdev zsh aliases

# "System" Aliases

alias ez="echo 'Updating zsh :D'; exec zsh"

## list
alias ls="ls --color -F "
alias la="ls -FA"
alias ll="ls -FAal"

alias cls="clear"
alias rm="rm -I"

## change dir
alias projects="cd ~/Developer/Projects/"
alias dotfiles="cd $DOT_FILES" # "~/.config/dotfiles/"

alias ..="cd .."
alias ...="cd ../.."

# Debug Aliases
alias fgdeb='echo -e " \033[30m[0:BLK] \033[31m[1:RED] \033[32m[2:GRN] \033[33m[3:YLW] \033[34m[4:BLU] \033[35m[5:MAG] \033[36m[6:CYN] \033[37m[7:WHT]"'
alias fgbrdeb='echo -e " \033[90m[0:GRY] \033[91m[1:RED] \033[92m[2:GRN] \033[93m[3:YLW] \033[94m[4:BLU] \033[95m[5:MAG] \033[96m[6:CYN] \033[97m[7:WHT]"'

# Programs Aliases

## make
alias mk="make"
alias mkr="make remote"
alias mb="make build"
alias mr="make run"

## git
alias gf="git pull"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"

## nvim
alias nres="nvim -S .session.vim"
alias nold="nvim -S .old_session.vim"
#alias nrswp="rm -rI ~/.local/state/nvim/swap"

# clang flags
#alias clangc="clang -xc -Wall -Wextra -Werror
#-Wpedantic -pedantic -pedantic-errors -std=c89"

