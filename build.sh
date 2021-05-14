#!/bin/bash
set -e
for f in $(find . -name '*.markdown' -type f); do
  if [ ${f} != "./index.markdown" ]; then
    toc="--toc"
    header="-H header.html"
    headline=$(head -1 $f | sed 's/^# //')
  else
    header="-H header-index.html"
    headline="Index"
  fi
  echo "Processing ${f}"
  pandoc \
    -s \
    ${toc} \
    -c typesafe.css \
    -c pandoc.css \
    -A footer.html \
    ${header} \
    --metadata pagetitle="$headline - lmbdfn's music blog" \
    "${f}" -o "${f/.markdown/.html}"
done
