#!/usr/bin/env sh

TIMEOUT_SECONDS=5
HOST=$1
PORT=$2

nc -z -w $TIMEOUT_SECONDS -v $HOST $PORT </dev/null; result=$?
#nmap -p $PORT $HOST

if [ "$result" != 0 ]; then
  echo "Connection to $HOST on port $PORT failed"
  exit 1
else
  echo "Connection to $HOST on port $PORT succeeded"
  exit 0
fi