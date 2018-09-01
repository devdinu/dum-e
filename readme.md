# Dum - E
Helper scripts - which is of use at times, and at times needed the most. just like stark's [dum-e](http://ironman.wikia.com/wiki/Dum-E_and_U).

## Usage

### Gitlab Scripts
set `GLTOKEN` the gitlab token for API access
- `clone_repos group_id`  - given id of group, downloads all the repos
- `clone_group_repos name` - given name of the group, downloads all the repos
- `get_group_info name` - given name of repo, show group info, can find id from here

##### Requirements
* [Jq](https://stedolan.github.io/jq/) JSON processor tool

### Golang
- Hot reload: rebuild and run the services on any `*.go` files
- `grld` which does `fswatch -r *.go | go build && ./$(basename $PWD)`
- `fw | echo` - pass any command to run on a filechange in dir.

##### Requirements
* [fswatch](https://github.com/emcrisostomo/fswatch)  file change notifier

### Docker
- `docker_clean`: does cleanup, by removing images with tag `<none>` and runs `system prune` 
- `load_docker`: starts default machine, and loads docker
