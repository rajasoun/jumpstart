#!/usr/bin/env bash


ANSIBLE_CMD="ansible-playbook -i ansible/inventory/topology  run.yml"
ANSIBLE_VAULT_FILE=" --vault-password-file=./secrets/.vault_pass"
LOG="> run.log 2>&1 &"


#vms=(  tracker )
#roles=( base )
vms=(   ckbox  tracker )
roles=( base ntp java maven docker ansible monit mmonit  )


for vm in "${vms[@]}"
do
    for role in "${roles[@]}"
    do
      echo "Install $role"
      CMD="$ANSIBLE_CMD -e role=$role -e hosts_to_run=$vm  -e env=$vm $ANSIBLE_VAULT_FILE"
      $CMD
    done
done

