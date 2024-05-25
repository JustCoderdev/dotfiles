# :! cp ./.zshrc ~

alias ez="echo 'Updating zsh :D\n'; exec zsh"

alias la="ls -AF; echo ''"
alias ll="ls -AFl | awk '{print \$9}'; echo ''"

alias cls="clear"
alias status="git status"

alias vis="nvim -S .session.vim"
alias vio="nvim -S .old_session.vim"

alias proj="cd ~/Developer/Projects/"
alias conf="cd ~/.config/"

alias ~="cd ~"
alias /="cd /"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

