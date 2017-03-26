#!/usr/bin/env bash

WORKSPACE="$HOME/Workspace/ck"

function setup_bats() {
    echo "Setting Up Bash Automation Test "
    echo "********************************"
    cd $WORKSPACE
    git clone https://github.com/rajasoun/bats
    cd bats
    dos2unix ./install.sh
    ./install.sh /usr/local
    cd $WORKSPACE
}

function setup_jumpstart() {
    echo "Setting Up Jump Start "
    echo "********************************"
    cd $WORKSPACE
    git clone https://github.com/rajasoun/jumpstart
    cd jumpstart
    scripts/gitconfig.sh
    cd $WORKSPACE
}

function setup_ops_tools(){
    gem install overcommit
    overcommit --install
    overcommit --sign
}

function setUp {
  echo "[Setup]"
  echo "*******************"
  cd $HOME
  mkdir -p $WORKSPACE
}

function tearDown {
    echo "[TearDown]"
    echo "**********"
}

setUp
setup_jumpstart
setup_bats
setup_ops_tools
trap tearDown EXIT




