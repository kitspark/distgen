#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT

src="$tmpdir/src"
dest="$tmpdir/out"

mkdir -p "$src"
echo "hello world" > "$src/file.txt"

# run the workflow
./workflow/zip.sh "$src" "$dest" "test.zip"

# check if zip exists
if [[ -f "$dest/test.zip" ]]; then
  echo "✅ Zip test passed: $dest/test.zip exists"
else
  echo "❌ Zip test failed: zip not created"
  exit 1
fi
