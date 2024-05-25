# justcoderdev zsh aliases

alias ez="echo 'Updating zsh :D'; exec zsh"

alias ls="ls --color -F "
alias la="ls -FA"
alias ll="ls -FAl"

alias cls="clear"
alias rm="rm -I"

alias mk="make"
alias mkr="make remote"

# git stuff
alias gs="git status"
alias ga="git add"
alias gc="git commit"

# nvim stuff
alias sim="sudo nvim"

alias vis="nvim -S .session.vim"
alias vio="nvim -S .old_session.vim"
alias vids="rm -rI ~/.local/state/nvim/swap"

alias sis="sudo vis"
alias sio="sudo vio"

# clang stuff
alias clangc="clang -xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89"

# directory movement
alias projects="cd ~/Developer/Projects/"
alias dotfiles="cd /.dotfiles/" # "~/.config/dotfiles/"
alias nixpath="cd /etc/nixos/"

alias ~="cd ~"
alias /="cd /"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

