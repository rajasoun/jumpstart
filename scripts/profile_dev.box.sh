#!/usr/bin/env bash

OUT_FILE="dev_box.profile.out"

### Utility Functions
function command_installed () {
	hash $1 &> /dev/null
}

function gem_installed() {
	gem list -i $1 >/dev/null 2>&1
}

function verify_os_ver() {

    case "$OSTYPE" in
      darwin*)  echo "Mac OS   :: Version - `sw_vers -productVersion` " >> $OUT_FILE ;;
      linux*)   echo "Linux OS :: Version - `lsb_release -d` " >> $OUT_FILE ;;
      msys*)    echo "Windows - MinGW " >> $OUT_FILE ;;
      cygwin*)  echo "Windows - CygWin " >> $OUT_FILE ;;
      *)        echo "unknown: $OSTYPE"  >> $OUT_FILE ;;
    esac
}

# $1 - Command Name
# $2 - Command Description
# $3 - Command to get Version
# $4 - Type  (command or gem )
function verify() {
	if $4_installed $1; then
		echo "$2 is Installated :: Version - "  $3   >> $OUT_FILE
	else
		echo "$2 Not Installated "  >> $OUT_FILE
	fi
}

########## EdaaS Dev Box Verifier ##################
echo "Dev Box Pre-requisite Verifier" > $OUT_FILE
echo "******************************" >> $OUT_FILE
echo "Developer Profile of " `whoami` >> $OUT_FILE

verify_os_ver
verify "ansible"  "Ansible" "`ansible --version`" command
verify "VBoxManage" "Virtual Box" "`VBoxManage -v`" command
verify "vagrant"  "Vagrant"  "`vagrant -v`" command
verify "java"  "JDK"  "`java -version 2>&1 | awk '/version/{print $NF}' `"  command
verify "mvn"  "Maven"  "`mvn -v | head -1 `" command
verify "git"  "Git "  "`git --version`"  command
verify "node"  "Node"  "`node -v `" command

