#!/usr/bin/env bash
# Usage: ./publish.sh <file.html> "Page Title"
# Adds the file to index.html, commits, and pushes.

set -e

FILE="$1"
TITLE="${2:-$1}"
DATE=$(date "+%b %d, %Y")

if [[ -z "$FILE" ]]; then
  echo "Usage: ./publish.sh <file.html> \"Page Title\""
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: '$FILE' not found in current directory."
  exit 1
fi

# Build the new entry line
ENTRY="      <a href=\"$FILE\" class=\"flex justify-between items-center bg-gray-900 border border-gray-800 hover:border-indigo-500 rounded-xl px-5 py-4 transition group\"><span class=\"text-white group-hover:text-indigo-400 font-medium transition\">$TITLE</span><span class=\"text-gray-600 text-xs\">$DATE</span></a>"

# Insert entry before ENTRIES_END marker
sed -i "s|      <!-- ENTRIES_END -->|$ENTRY\n      <!-- ENTRIES_END -->|" index.html

# Stage, commit, push
git add index.html "$FILE"
git commit -m "Add: $TITLE"
git push

echo ""
echo "✓ Published: https://nishant7007.github.io/$FILE"
