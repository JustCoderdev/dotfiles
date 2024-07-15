#> justcoderdev zsh aliases

# "System" Aliases

alias ez="echo 'Updating zsh :D'; exec zsh"

## list
unalias l
alias ls="ls --color -F "
alias la="ls -Fa"
alias ll="ls -Fla"

alias cls="clear"
alias rm="rm -I"

alias cl="clear"
alias sls="ls --color -F "

alias l="ls --color -F "
alias scls="clear"

## change dir
# alias github="cd /home/${USER}/Developer/Github/"
# alias projects="cd /home/${USER}/Developer/Projects/"
# alias dotfiles="cd $DOT_FILES" # "~/.config/dotfiles/"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Push Dir Aliases - Save Directory
alias sd='echo $(pwd) > "/home/$USER/.zsh/sd" && cat "/home/$USER/.zsh/sd"'
alias sdl='cd $(cat "/home/$USER/.zsh/r_wd")'
alias sdc='cat "/home/$USER/.zsh/r_wd"'

# Debug Aliases
alias fgdeb='echo -e " \033[30m[0:BLK] \033[31m[1:RED] \033[32m[2:GRN] \033[33m[3:YLW] \033[34m[4:BLU] \033[35m[5:MAG] \033[36m[6:CYN] \033[37m[7:WHT]"'
alias fgbrdeb='echo -e " \033[90m[0:GRY] \033[91m[1:RED] \033[92m[2:GRN] \033[93m[3:YLW] \033[94m[4:BLU] \033[95m[5:MAG] \033[96m[6:CYN] \033[97m[7:WHT]"'

# Programs Aliases

## make
alias mk="make"
alias mc="make clean"
alias mb="make build"
alias mr="make run"

## git
alias gs="git status"
alias gl="git log --all --color --decorate --oneline --graph"
alias gd="git diff"

alias gf="git fetch"
alias gp="git push"

alias ga="git add"
alias gc="git commit"


## docker
alias dp="docker ps -a"


## nvim
alias nres="nvim -S .session.vim"
alias nold="nvim -S .old_session.vim"
#alias nrswp="rm -rI /home/${USER}/.local/state/nvim/swap"

# clang flags
#alias clangc="clang -xc -Wall -Wextra -Werror
#-Wpedantic -pedantic -pedantic-errors -std=c89"

