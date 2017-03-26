#!/usr/bin/env sh
mkdir -p ~/Workspace/ck/
cd ~/Workspace/ck/
git clone https://github.com/rajasoun/jumpstart
cd jumpstart
gem install overcommit
overcommit --install
overcommit --sign
scripts/gitconfig.sh


