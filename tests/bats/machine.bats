#!/usr/bin/env bats
#


@test "Check If vagrant-vm machine Is Up" {
    result="$(VBoxManage list runningvms | grep vagrant-vm | wc -l)"
    [ "$result" -eq 1 ]
}


@test "Check vagrant-vm is Reachable  " {
  run ping -c 1 vagrant-vm.dev
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "1 packets transmitted, 1 packets received, 0.0% packet loss" ]
}
