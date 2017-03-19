#!/usr/bin/env bash

### force kill vagrant

option=$1
DESC="CK In a Box VMs"

set -e

case "$option" in
    clean)
       echo -n "Clean Up $DESC "
       ps -ef   | grep -v grep | grep VBoxHeadless | awk '{print $2}' | xargs kill -9
    ;;

    *)
        echo "Usage: ./vagrant_manager.sh  {clean}" >&2
        exit 1
    ;;
esac
exit 0