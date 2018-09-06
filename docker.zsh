alias dpsid="echo $(docker ps | grep -v CONTAINER | awk '{ print $1}')"
alias dimg_notags="echo $(docker images | grep none | awk '{ print $3}')"

function docker_clean {
    docker images -a | grep -iE '<none>' | awk '{print $3}' | xargs -L1 docker rmi -f
    echo y | docker system prune
}

export docker_clean
