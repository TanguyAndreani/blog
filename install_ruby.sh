#!/bin/bash --login
set -e
sudo apk add yaml-dev
sudo apk add yaml-static
gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
. ~/.bash_profile
rvm install ruby 3.2.4
echo "source $HOME/.rvm/scripts/rvm" >> $HOME/.bashrc
echo "source $HOME/.rvm/scripts/rvm" >> $HOME/.zshrc
rvm use ruby 3.2.4
bundle install
gem install rerun
gem install ruby-lsp
