#!/usr/bin/env bats
#


@test "Check VirtualBox is Installed" {
    command -v VBoxManage
}

@test "Check VirtualBox Version is 5.1.14r112924" {
    run echo `VBoxManage --version`
    [ $output = "5.1.18r114002" ]
}  

@test "Check Vagrant is Installed" {
    command -v vagrant
}

@test "Check Vagrant Version is 1.9.2" {
    run echo  `vagrant --version` 
    [ $output = "Vagrant 1.9.2" ]
}  

@test "Check Git is Installed" {
    command -v git
}

@test "Check Git Version is 2.12.0" {
    run echo  `git --version` 
    [ $output = "git version 2.12.2" ]
} 

@test "Check Java is Installed" {
    command -v java
}

@test "Check Java Version is 1.8.0_60" {
    run bash -c "echo  `java -version 2>&1 | awk '/version/ {print $3}'`"
    [ "$status" -eq 0 ]
    [ "$output" = "1.8.0_60" ]
}


