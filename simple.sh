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
    docker images -a | grep -iE '<none>' | awk '{print $3}' | xargs -L1 docker rmi -f
    echo y | docker system prune
}

#---------------------------------------------------------------------------------

function wifirestart {
    if [[ -z "$(command -v networksetup)" ]]; then
        echo "networksetup not supported"
        return -10
    fi
    networksetup -setairportpower en0 off && networksetup -setairportpower en0 on
}

alias clean_test='RAILS_ENV=test bundle exec rake db:drop db:create:all db:migrate && bundle exec rake'
alias be='RAILS_ENV=test bundle exec $*'
alias bespec='RAILS_ENV=test bundle exec rspec $*'
