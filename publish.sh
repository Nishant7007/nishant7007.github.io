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

# Build card HTML (single line for sed compatibility)
if [[ -n "$DESC" ]]; then
  ENTRY="      <a href=\"$FILE\" data-title=\"$TITLE\" data-desc=\"$DESC\" class=\"flex justify-between items-start bg-gray-900 border border-gray-800 hover:border-indigo-500 rounded-xl px-5 py-4 transition group\"><div><p class=\"text-white group-hover:text-indigo-400 font-medium text-sm transition mb-0.5\">$TITLE</p><p class=\"text-gray-500 text-xs\">$DESC</p></div><span class=\"text-gray-600 text-xs whitespace-nowrap ml-4 mt-0.5\">$DATE</span></a>"
else
  ENTRY="      <a href=\"$FILE\" data-title=\"$TITLE\" class=\"flex justify-between items-center bg-gray-900 border border-gray-800 hover:border-indigo-500 rounded-xl px-5 py-4 transition group\"><span class=\"text-white group-hover:text-indigo-400 font-medium text-sm transition\">$TITLE</span><span class=\"text-gray-600 text-xs\">$DATE</span></a>"
fi

# Insert before ENTRIES_END marker
sed -i "s|      <!-- ENTRIES_END -->|$ENTRY\n      <!-- ENTRIES_END -->|" index.html

git add index.html "$FILE"
git commit -m "Add: $TITLE"
git push

echo ""
echo "Published: https://nishant7007.github.io/$FILE"
