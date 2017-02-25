#!/usr/bin/env bats
#


@test "Check If testdrive machine Is Up" {
    result="$(VBoxManage list runningvms | grep testdrive | wc -l)"
    [ "$result" -eq 1 ]
}


@test "Check testdrive is Reachable  " {
  run ping -c 1 testdrive.dev
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "1 packets transmitted, 1 packets received, 0.0% packet loss" ]
}
