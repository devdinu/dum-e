#!/bin/bash

set -e

COMMANDS_DIR=$(dirname $BASH_SOURCE)

function gh_clone_repos {
   echo "args: ${@}"
   bash  "$COMMANDS_DIR/git/clone_repos.sh" $@
}

export -f gh_clone_repos
