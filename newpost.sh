#!/bin/bash
set -e
today=$(date +'%Y-%m-%d')
title="${1}"
title_min=$(ruby -e "print \"${1}\".strip.gsub(/\s/, '-').gsub(/[^a-zA-Z0-9\-]/, '').downcase")
cat > "${today}-${title_min}.markdown" <<EOFF
---
title: ${1}
mathjax: true
draft: false
date: ${today}
permalink: ${today}-${title_min}.html
---

<div class="abstract">
First lines
</div>

When \$a \\ne 0$, there are two solutions to \$ax^2 + bx + c = 0\$ and they are
  \$\$x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}\$\$

And here is [some](https://google.fr) quote:

>Lorem ipsum dolor sit amet!

## Level two title

\`\`\`js
console.log('hello')
\`\`\`
EOFF
