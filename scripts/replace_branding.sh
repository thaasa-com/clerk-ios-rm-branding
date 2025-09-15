#!/usr/bin/env bash
set -euo pipefail

# Find all Swift files
find Sources -name "*.swift" -type f | while read -r file; do
  # 1) Comment when the token is the first non-space on the line.
  #    e.g. "    SecuredByClerkView()" -> "    //SecuredByClerkView()"
  perl -0777 -i -pe 's/^(\s*)SecuredByClerkView\(\)/$1\/\/SecuredByClerkView()/mg' "$file" 2>/dev/null || true
  perl -0777 -i -pe 's/^(\s*)SecuredByClerkFooter\(\)/$1\/\/SecuredByClerkFooter()/mg' "$file" 2>/dev/null || true

  # 2) For any remaining inline occurrences, use a block comment to avoid nuking the rest of the line.
  #    Negative lookbehind avoids touching ones we already commented with //.
  perl -0777 -i -pe 's/(?<!\/\/)SecuredByClerkView\(\)/\/\*SecuredByClerkView()\*\//g' "$file" 2>/dev/null || true
  perl -0777 -i -pe 's/(?<!\/\/)SecuredByClerkFooter\(\)/\/\*SecuredByClerkFooter()\*\//g' "$file" 2>/dev/null || true
done
