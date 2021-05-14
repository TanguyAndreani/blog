#!/bin/bash
set -e
today=$(date +'%Y-%m-%d')
cat > ${today}-${1}.markdown <<EOFF
# What I practiced this week

<div class="dates">
Date of first word: $today

Date of publishing: FILLME
</div>
EOFF
