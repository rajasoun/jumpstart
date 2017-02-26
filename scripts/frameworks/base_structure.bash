#!/usr/bin/env bash

function install_mac() {
    echo "Mac"
}

function install_windows() {
    echo "Windows"
}

function install_linux() {
    echo "Linux"
}

function setUp {
  echo "[Setup]"
  echo "*******************"

    case "$OSTYPE" in
      msys*)    install_windows  ;;
      cygwin*)  install_windows  ;;
      darwin*)  install_mac  ;;
      linux*)   install_linux ;;
      *)        echo "unknown: $OSTYPE";exit  ;;
    esac
}

function tearDown {
    echo "[TearDown]"
    echo "***************************"
}

setUp
trap tearDown EXIT
