#!/usr/bin/env bash


ANSIBLE_CMD="ansible-playbook -i ansible/inventory/topology  run.yml"
ANSIBLE_VAULT_FILE=" --vault-password-file=./secrets/.vault_pass"
LOG="> run.log 2>&1 &"

ENV='vagrant-vm'
roles=( base ntp java maven docker ansible mmonit monit git-repository)
for role in "${roles[@]}"
do
  echo "Install $role"
  CMD="$ANSIBLE_CMD -e role=$role -e hosts_to_run=$ENV  -e env=$ENV $ANSIBLE_VAULT_FILE"
  $CMD
done

ENV='cloud-vm'
roles=( base ntp java maven docker ansible mmonit monit git-repository)
for role in "${roles[@]}"
do
  echo "Install $role"
  CMD="$ANSIBLE_CMD -e role=$role -e hosts_to_run=$ENV  -e env=$ENV $ANSIBLE_VAULT_FILE"
  $CMD
done

