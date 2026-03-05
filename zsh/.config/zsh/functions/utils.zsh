#!/bin/zsh

# Remove the current directory
rmcu () {
  local current_dir="$PWD"
  local parent_dir="$(dirname "$current_dir")"
  cd "$parent_dir" || {
    echo "Error: Failed to change directory to '$parent_dir'." >&2
    return 1
  }
  command rm -rf "$current_dir"
}

# Weather information using wttr.in
weather () {
  if [ -z "$1" ]; then
    curl "wttr.in"
  else
    curl "wttr.in/$1"
  fi
}

# Get public IP address
public_ip () {
  echo "IPv4 -> $(curl -s https://ipv4.icanhazip.com/)"
  echo "IPv6 -> $(curl -s https://ipv6.icanhazip.com/)"
}
