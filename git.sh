function pull_repos {
    dir=${1-$PWD}
    pushd $dir > /dev/null
    find . -iname '.git' -type d  | \
        parallel -P 3 'd=$(dirname {}); pushd $d > /dev/null; echo "pulling $PWD"; git pull; popd $d > /dev/null'
    popd $dir > /dev/null
}
