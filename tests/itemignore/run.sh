#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT

# Prepare dummy files in tmpdir
mkdir -p "$tmpdir/build" "$tmpdir/logs" "$tmpdir/tmp/nested"
touch "$tmpdir/build/output.log" "$tmpdir/build/output.bin"
touch "$tmpdir/logs/app.log" "$tmpdir/logs/debug.log"
touch "$tmpdir/tmp/nested/file.txt"
ln -s "$tmpdir/logs/app.log" "$tmpdir/symlink.log"

echo "[*] Created dummy files:"
find "$tmpdir" -maxdepth 3 -type f -o -type l -o -type d

# Write .itemignore file
cat > "$tmpdir/.itemignore" <<EOF
# Kill build artifacts
build/*

# Logs
logs/*.log

# Entire tmp dir
tmp/

# A symlink
symlink.log
EOF

echo "[*] Contents of .itemignore:"
cat "$tmpdir/.itemignore"

# Run the workflow script from repo root
./workflow/itemignore.sh "$tmpdir/.itemignore"

echo "[*] Remaining files after cleanup:"
find "$tmpdir" -maxdepth 3 -type f -o -type l -o -type d
ls $tmpdir
# Check if nukes actually worked
if [[ -e "$tmpdir/build/output.log" || -e "$tmpdir/build/output.bin" \
   || -e "$tmpdir/logs/app.log" || -e "$tmpdir/logs/debug.log" \
   || -d "$tmpdir/tmp" || -e "$tmpdir/symlink.log" ]]; then
  echo "❌ Itemignore test failed: some targets still exist"
  exit 1
else
  echo "✅ Itemignore test passed"
fi