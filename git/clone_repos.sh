#!/bin/bash

while getopts ":k:o:u:t:d:" opt; do
    case $opt in
        k)
            echo "using ssh key: $OPTARG" >&2
            keyfile=$OPTARG
            ;;
        o) org=$OPTARG ;;
        u) user=$OPTARG ;;
        t) token=$OPTARG ;;
        d) workdir=$OPTARG ;;
        \?) echo "Usage: gh_clone_org_repos -o <organisation> -u <github_user> -t <api_token>" >&2 ;;
    esac
done
shift $((OPTIND -1))

function pull_repos {
    dir=${1-$PWD}
    pushd $dir > /dev/null
    find . -iname '.git' -type d  | \
        parallel -P 3 'd=$(dirname {}); pushd $d > /dev/null; echo "pulling $PWD"; git pull; popd $d > /dev/null'
    popd $dir > /dev/null
}


function clone_repo {
    repo_url=${1:?repo url is not passed}
    ssh_key=${2:-"~/.ssh/id_rsa"}
    git_repo_name=$(echo $repo_url | rev | cut -d '/' -f 1 | rev)
    repo_name=$(echo $git_repo_name | cut -d '.' -f 1)
    if [ -d "$repo_name" ];then
        echo "directory $repo_name already exists"
    else
        git clone $repo_url --config core.sshCommand="ssh -i ${ssh_key}"
    fi
}

export -f clone_repo

if [ -z ${org} ]; then
    echo "pass organisation with argument -o"
    exit 1
fi
if [ -z ${user} ]; then
    echo "pass user with argument -u"
    exit 1
fi
if [ -z ${token} ]; then
    echo "pass token with argument -t"
    exit 1
fi
if [ -z ${workdir} ]; then 
    workdir=${org}
fi


echo "cloning into directory $workdir"
mkdir -p $workdir
pushd $workdir
repos=$(curl -H "Accept: application/vnd.github.v3+json" -u $user:$token https://api.github.com/orgs/${org}/repos \
    | jq '.[].ssh_url')
echo $repos | xargs -P0 -n1 -I{} bash -c "clone_repo {} ${keyfile}" $0 
popd
