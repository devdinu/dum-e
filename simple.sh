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
