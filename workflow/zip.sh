#!/usr/bin/env bash
set -euo pipefail

# usage: ./workflow/zip.sh <source_dir> <target_path> <output_filename>
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <source_dir> <target_path> <output_filename>" >&2
  exit 1
fi

src="$1"
dest="$2"
outfile="$3"

mkdir -p "$dest"
zip -r "$dest/$outfile" "$src"
