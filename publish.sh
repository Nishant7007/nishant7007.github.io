#!/usr/bin/env bash
# Usage: ./publish.sh <file.html> "Title" ["Description"]

set -e

FILE="$1"
TITLE="${2:-$1}"
DESC="${3:-}"
DATE=$(date "+%b %d, %Y")

if [[ -z "$FILE" ]]; then
  echo "Usage: ./publish.sh <file.html> \"Title\" \"Description (optional)\""
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: '$FILE' not found."
  exit 1
fi

# Build sidebar entry HTML (single line for sed compatibility)
if [[ -n "$DESC" ]]; then
  ENTRY="      <a href=\"$FILE\" data-title=\"$TITLE\" data-desc=\"$DESC\" class=\"block rounded-lg px-3 py-2.5 hover:bg-gray-800 transition cursor-pointer\"><p class=\"text-gray-200 text-sm font-medium leading-snug\">$TITLE</p><p class=\"text-gray-500 text-xs mt-0.5 truncate\">$DESC</p></a>"
else
  ENTRY="      <a href=\"$FILE\" data-title=\"$TITLE\" class=\"block rounded-lg px-3 py-2.5 hover:bg-gray-800 transition cursor-pointer\"><p class=\"text-gray-200 text-sm font-medium leading-snug\">$TITLE</p><p class=\"text-gray-500 text-xs mt-0.5\">$DATE</p></a>"
fi

# Guard against duplicate entries
if grep -q "href=\"$FILE\"" index.html; then
  echo "Error: '$FILE' is already in the index. Edit index.html manually to update it."
  exit 1
fi

# Insert before ENTRIES_END marker
sed -i "s|      <!-- ENTRIES_END -->|$ENTRY\n      <!-- ENTRIES_END -->|" index.html

git add index.html "$FILE"
git commit -m "Add: $TITLE"
git push

echo ""
echo "Published: https://nishant7007.github.io/$FILE"
