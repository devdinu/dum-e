
export GITLAB_API="https://gitlab.com/api/v4"

# should've set env GLTOKEN as your access token
# $1 is the group id you want to clone repos from

function clone_repos {
    curl $GITLAB_API/groups/$1 -H "Private-Token: $GLTOKEN" | \
        jq '.projects[] .ssh_url_to_repo' | \
        xargs -L1  git clone
}

# pass name of group as parameter
function clone_group_repos {
    name=$1
    pid=$(curl $GITLAB_API/groups\?search\=$name -H "Private-Token: $GLTOKEN"  | jq '.[0] .id')
    echo "cloning repos of $name id: $pid"
    clone_repos $pid
}

function get_group_info {
    name=$1
    curl $GITLAB_API/groups\?search\=${name} -H "Private-Token: $GLTOKEN"  | jq
}
