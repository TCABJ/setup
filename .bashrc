

# Aliases
  # List merged branches
  alias gbm='git branch --merged | egrep -v "master"'
  # Delete merged branches
  alias gbmd='gbm | xargs git branch -d'
  # Delete all branches except master
  alias gbad='git branch | grep -v "master" | xargs git branch -D'

# Script for running SSH agent for connecting to github
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add ~/.ssh/github
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add ~/.ssh/github
fi

unset env
