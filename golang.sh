#!/bin/bash

grun() {
    name=$1
    def=$(basename $PWD)
    file="${name:-$def}"
    go build -o $file && echo "build completed....$file" && nohup ${file} >test.out 2>&1 &
    echo "using build file $file... with pid: $!"
}

ghotrun() {
    if [[ -z "$1" ]] ; then
        echo "name of process is required to do hot run"
        return -2
    fi
    name=$1
    epid=$(get_pid $name)
    echo "ghotrun $name $epid...."
    if [[ "$epid" -ne "" ]] ; then
        echo "killing process $name pid: $epid" && kill -9 $epid
    fi
    echo "running process pid: $name"
    grun $name #>/dev/null 2>&1
}

grlod() {
    id=$TMPDIR$(uniqid)
    ghotrun $id
    fswatch *.go | xargs -L1 bash -c "ghotrun ${id}"
    #fswatch -o *.go | xargs -L1 $(echo $shell) -c "echo reloading.... && ghotrun $id"
}

get_pid() {
    if [[ -z "$1" ]] ; then
        echo "name of process is required to get pid"
        return -3
    fi
    name=$1
    ps aux  | grep $name | grep -v grep | awk '{ print $2 }'
}

uniqid() {
    echo "${USER}_$(basename $PWD)_$(date +'%s')"
}

if [[ "$BASH" -ne "" ]];then
    export -f grlod
    export -f ghotrun
    export -f get_pid
    export -f grun
    export -f uniqid
fi
# Start pg server
alias sredis='nohup redis-server $HOME/Config/redis.config &'
