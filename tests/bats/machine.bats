#!/usr/bin/env bats
#


@test "Check If ignitor machine Is Up" {
    result="$(VBoxManage list runningvms | grep ignitor | wc -l)"
    [ "$result" -eq 1 ]
}


@test "Check ignitor is Reachable  " {
  run ping -c 1 ignitor.dev
  [ "$status" -eq 0 ]
  [ "${lines[3]}" = "1 packets transmitted, 1 packets received, 0.0% packet loss" ]
}
