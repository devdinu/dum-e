function pull_repos {
    dir=${1-$PWD}
    pushd $dir > /dev/null
    find . -iname '.git' -type d  | \
        parallel -P 3 'd=$(dirname {}); pushd $d > /dev/null; echo "pulling $PWD"; git pull; popd $d > /dev/null'
    popd $dir > /dev/null
}


function clone_repo {
    repo_url=${1:?repo url is not passed}
    git_repo_name=$(echo $repo_url | rev | cut -d '/' -f 1 | rev)
    repo_name=$(echo $git_repo_name | cut -d '.' -f 1)
    if [ -d "$repo_name" ];then
        echo "directory $repo_name already exists"
    else
        echo "cloning $repo_url ..."
        git clone $repo_url
    fi
}

function gh_clone_org_repos {
    GH_USER=${1:?pass user id as first arg}
    GH_TOKEN=${2:?pass github token as second arg}
    GH_ORG=${3:?pass orgname as third arg}
    CLONE_DIR=${4:-$GH_ORG}
    echo "cloning into directory $CLONE_DIR"
    mkdir -p $CLONE_DIR
    pushd $GH_ORG
    repos=$(curl -H "Accept: application/vnd.github.v3+json" -u $GH_USER:$GH_TOKEN https://api.github.com/orgs/${GH_ORG}/repos \
        | jq '.[].ssh_url')
    echo $repos | xargs -P0 -n1 -I{} bash -c 'clone_repo {}'
    popd
}

export -f clone_repo
