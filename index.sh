#!/bin/bash
set -e
rm -f index.markdown
sorted=$(ls *.markdown)
for f in ${sorted}; do
  headline=$(head -1 $f | sed 's/^# //')
  echo "- [${f:0:10} ${headline}](${f/.markdown/.html})" >> index.markdown
done
bash ./build.sh
