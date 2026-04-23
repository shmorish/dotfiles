#!/bin/zsh

docker_node_12 () {
  docker run -it --rm -v "$(pwd):/app" -w /app node:12 bash
}
