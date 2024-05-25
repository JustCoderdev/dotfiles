# :! cp ./.zshrc ~

alias ez="echo 'Updating zsh :D\n'; exec zsh"

alias ls="ls -F"
alias la="ls -AF"
alias ll="ls -AFl | awk '{print \$9}'"

alias cls="clear"
alias rm="rm -I"

# git stuff
alias gs="git status"
alias ga="git add"

# nvim stuff
alias vis="nvim -S .session.vim"
alias vio="nvim -S .old_session.vim"
alias vids="rm -rI ~/.local/state/nvim/swap"

# directory movement
alias proj="cd ~/Developer/Projects/"
alias conf="cd ~/.config/"

alias ~="cd ~"
alias /="cd /"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

