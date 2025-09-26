#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path_to_.itemignore>"
  exit 1
fi

ignore_file="$(realpath "$1")"
cwd="$(dirname "$ignore_file")"

if [ ! -f "$ignore_file" ]; then
  echo "Error: $ignore_file does not exist"
  exit 1
fi

while IFS= read -r line; do
  # skip empty lines or comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # expand the glob relative to cwd
  matches=$(cd "$cwd" && eval "echo $line" || true)

  for path in $matches; do
    target="$cwd/$path"
    if [ -f "$target" ] || [ -L "$target" ]; then
      rm -f "$target"
      echo "Deleted file $target"
    elif [ -d "$target" ]; then
      rm -rf "$target"
      echo "Deleted directory $target"
    fi
  done
done < "$ignore_file"
