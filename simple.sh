#!/bin/bash

alias fs='fswatch -r . | xargs -L1 $*'


#---------------------------------------------------------------------------------
# Docker
#---------------------------------------------------------------------------------

alias dpsid="echo $(docker ps | grep -v CONTAINER | awk '{ print $1}')"
alias di_notags="echo $(docker images | grep none | awk '{ print $3}')"

function load_docker {
    echo "loading docker..."
    docker-machine start default
    eval "$(docker-machine env)"
}

function docker_clean {
    docker images -f "dangling=true" | xargs -L1 docker rmi -f
    docker system prune -f #containers,dangling images, network, cache
}

#---------------------------------------------------------------------------------

function wifirestart {
    if [[ -z "$(command -v networksetup)" ]]; then
        echo "networksetup not supported"
        return -10
    fi
    networksetup -setairportpower en0 off && networksetup -setairportpower en0 on
}

function tm {
    s=$1
    tmux attach -t $s || tmux new -s $s
}

function sshv {
    [[ $1 -eq "" ]] && echo "mention an instance!" && exit 1
    ssh $1 -t 'bash -o vi'
}

alias clean_test='RAILS_ENV=test bundle exec rake db:drop db:create:all db:migrate && bundle exec rake'
alias be='RAILS_ENV=test bundle exec $*'
alias bespec='RAILS_ENV=test bundle exec rspec $*'
alias tmxsave='~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias tmxrestore='~/.tmux/plugins/tmux-resurrect/scripts/restort.sh'

# command aliases/overrides

alias ag='ag --hidden $*'
alias cat='less $*'
#alias ssh='sshv $*'
