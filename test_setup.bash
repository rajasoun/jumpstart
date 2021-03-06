#!/usr/bin/env bash

function setUp {
  echo "[Setup]"
  echo "*******************"
}

function check_status {
  env=$1
  env_status="`vagrant status $env  | grep $env | awk '{print $2}'`"
    case "$env_status" in
      aborted*)  echo "$env Aborted" ;;
      running*)  echo "$env Running" ;;
      *)         echo "unknown: $env_status";exit  ;;
    esac
}

function tearDown {
   echo "[TearDown]"
   echo "***************************"
}

setUp
#bats tests/bats/
machine_name="ignitor"
check_status $machine_name
testinfra -v --host=$machine_name --ansible-inventory=ansible/inventory/vagrant.py --connection=ansible tests/testinfra/
trap tearDown EXIT