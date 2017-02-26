#!/usr/bin/env bash

function patch_markupsafe_for_windows(){
    ##WorkAround For markupsafe Without Speedups##
    temp=/tmp/ansible-babun-build
    mkdir -p $temp
    current_dir=`pwd`
    cd $temp
    pip uninstall markupsafe
    git clone https://github.com/gtback/markupsafe.git
    cd markupsafe
    python setup.py --without-speedups install
    cd $current_dir
    rm -rf $temp
    ##WorkAround Ends##

}

function configure_ssh_agent_for_windows() {
cat <<EOF > ~/.ssh_wrapper
    #!/bin/bash
    SSH_ENV="$HOME/.ssh/environment"

     # Source SSH Agent
    function start_agent {
        echo "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "\${SSH_ENV}"
        echo succeeded
        chmod 600 "\${SSH_ENV}"
        . "\${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add;
    }

    # Source SSH settings, if applicable
    if [ -f "\${SSH_ENV}" ]; then
        . "\${SSH_ENV}" > /dev/null
        ps -ef | grep \${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || { start_agent; }
    else
        start_agent;
    fi
EOF

}

function configure_ansible() {
    ansible_default_dir=/etc/ansible
    if [ ! -d $ansible_default_dir ]; then
        mkdir -p $ansible_default_dir
        [ ! -f hosts ] && echo "localhost ansible_connection=local" > $ansible_default_dir/hosts
    fi
}

function install_windows() {
    echo "Setting up ansible pre-requisties on windows...."
    pact install  gcc-g++
    pact install  curl openssl gettext ca-certificates wget openssh
    pact install python-paramiko  python-crypto python-openssl python-setuptools
    pact install libffi-devel  libyaml-devel openssl-devel

    echo "Installing pip & Ansible Dependent Modules"
    curl -skS https://bootstrap.pypa.io/get-pip.py | python
    pip install pyyaml jinja2 requests testinfra


    patch_markupsafe_for_windows
    #    pip install --upgrade  wheel
    #    pip install --upgrade  cryptography
    #    pact update cygwin-devel
    #    pact update
    #    pip install --upgrade ansible==2.2
    #    /usr/bin/rebaseall -v
    pip install ansible
    configure_ansible
    configure_ssh_agent_for_windows

    echo "You can use ~/.ssh_wrapper in your .bash_profile or .zsh_profile to automatically unlock your private SSH key on opening Babun"
    [ ! -f ~/.zsh_profile ] && touch ~/.zsh_profile
    chmod 755 ~/.zsh_profile  ~/.ssh_wrapper
    . ~/.zsh_profile

    if test -f "scripts/configs/fstab"; then cp scripts/configs/fstab /etc/fstab ;fi
    if test -f "scripts/configs/.zshrc"; then cp scripts/configs/.zshrc ~/.zshrc ;fi


}


function install_mac() {
    sudo launchctl limit maxfiles 1024 unlimited

    [ ! -f /usr/local/bin/brew ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    [ ! -f /usr/bin/easy_install ] && /usr/bin/curl  https://bootstrap.pypa.io/ez_setup.py -o - | /usr/local/bin/python
    [ ! -f /usr/local/bin/pip ] && easy_install --user pip
    printf 'if [ -f ~/.bashrc ]; then\n  source ~/.bashrc\nfi\n' >> $HOME/.profile
    printf 'export PATH=$PATH:$HOME/Library/Python/2.7/bin\n' >> $HOME/.bashrc

    source $HOME/.profile

    pip install --user --upgrade ansible==2.2
    type -a ansible
    pip install --user testinfra
    # sudo mkdir /etc/ansible
    # sudo curl -L https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -o /etc/ansible/ansible.cfg
    configure_ansible
}

function install_linux() {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install python python-setuptools python-paramiko python-crypto
    sudo easy_install pip
    sudo pip install --upgrade  ansible==2.2
    type -a ansible
    configure_ansible
    sudo pip install  testinfra
}


function setUp {
  echo "[Ansible Installer]"
  echo "*******************"

    case "$OSTYPE" in
      msys*)    install_windows  ;;
      cygwin*)  install_windows  ;;
      darwin*)  install_mac  ;;
      linux*)   install_linux ;;
      *)        echo "unknown: $OSTYPE";exit  ;;
    esac
}

function tearDown {
    echo "[Ansible Installation Check]"
    echo "***************************"
    ansible -i /etc/ansible/hosts -m ping all
    ansible all -i /etc/ansible/hosts -m shell -a 'hostname'
}

setUp
trap tearDown EXIT


