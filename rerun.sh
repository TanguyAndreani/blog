#!/bin/bash
rvm use
ruby --version
rerun -p '*.markdown' -i 'index.markdown' bundle exec ./build.rb \\--enable-drafts