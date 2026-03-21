#!/bin/zsh

docker_stop_containers () {
  docker stop $(docker ps -qa) 2> /dev/null
}

docker_remove_stopped () {
  docker rm $(docker ps -qa) 2> /dev/null
}

docker_remove_unused_images () {
  docker rmi -f $(docker images -qa) 2> /dev/null
}

docker_remove_unused_volumes () {
  docker volume rm $(docker volume ls -q) 2> /dev/null
}

docker_remove_unused_networks () {
  docker network rm $(docker network ls -q) 2> /dev/null
}

docker_remove_all () {
  docker_stop_containers
  docker_remove_stopped
  docker_remove_unused_images
  docker_remove_unused_volumes
  docker_remove_unused_networks
}

docker_delete_cache () {
  docker system prune -a --volumes
}
