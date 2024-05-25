# justcoderdev zsh aliases

alias ez="echo 'Updating zsh :D'; exec zsh"

alias ls="ls -F"
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
alias vis="nvim -S .session.vim"
alias vio="nvim -S .old_session.vim"
alias vids="rm -rI ~/.local/state/nvim/swap"

# clang stuff
alias clangf="clang -xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89"

# directory movement
alias projects="cd ~/Developer/Projects/"
alias dotfiles="cd ~/.config/dotfiles/"
alias nos="cd /etc/nixos"

alias ~="cd ~"
alias /="cd /"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

