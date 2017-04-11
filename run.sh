#!/usr/bin/env bash


ANSIBLE_CMD="ansible-playbook -i ansible/inventory/topology  run.yml"
ANSIBLE_VAULT_FILE=" --vault-password-file=./secrets/.vault_pass"
LOG="> run.log 2>&1 &"

ENV='ckbox'
#roles=( mmonit )
roles=( base ntp java maven docker ansible monit mmonit  )
for role in "${roles[@]}"
do
  echo "Install $role"
  CMD="$ANSIBLE_CMD -e role=$role -e hosts_to_run=$ENV  -e env=$ENV $ANSIBLE_VAULT_FILE"
  $CMD
done

