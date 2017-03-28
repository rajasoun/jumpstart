# About
 **jumpstart** helps developers to setup their development environment in a
 common way  & deploy softwares using ansible roles

## Minimal requirements
* Ensure you are connected to the Internet (required to download open source libraries etc.)

## Prerequisites
The developer environment relies on the components shown below.
This project is tested with the following versions see below.
Your mileage may vary if you use different versions of the software below.

| S.No | Software             | Version          | Description                |
|:-----|:---------------------|:-----------------|:---------------------------|
| 1    | [Oracle Virtual Box] | 5.1.18 r114002   | Virtualization platform    |
| 2    | [Virtual Box Ext]    | 5.1.18 r114002   | Addition H/W support tools |
| 3    | [Hashicorp Vagrant]  | 1.9.2            | Configuration              |
| 4    | [Git CLI Client]     | 2.12.0           | SCM command line client    |
| 5    | [JDK]                | 1.8.0_102        | Java runtime               |
| 6    | [Maven]              | 3.3.9            | Java build tool            |
| 7    | [Node.js]            | v6.9.4           | Javascript runtime         |

#### Workspace Setup
The idea is to allow developers to store and edit source files on their system (Windows, Mac).
They can use their preferred IDE ([Eclipse], [IntelliJ]), and test/deploy/run code on a virtual machine.
The local file system folders are shared with the guest OS by adding entries in the vagrant file.

Start out by creating a **_Workspace_** folder in your home folder.
Under _Workspace_ create the root folder **ck** for the source code.
For user 'joe' the home folder on a Mac system is _/home/joe_
For user 'mary' the home folder on a Windows is _C:\Users\mary_.

```sh
https://raw.githubusercontent.com/rajasoun/jumpstart/master/set-repo.sh
```

Windows support
---------------

Jumpstart will detect Windows guests and hosts and use the appropriate
path for the ```hosts``` file: ```%WINDIR%\System32\drivers\etc\hosts```

By default on a Windows host, the ```hosts``` file is not writable without
elevated privileges. If Jumpstart detects that it cannot overwrite the file,
it will attempt to do so with elevated privileges, causing the
[UAC](http://en.wikipedia.org/wiki/User_Account_Control) prompt to appear.

To avoid the UAC prompt, open ```%WINDIR%\System32\drivers\etc\``` in
Explorer, right-click the hosts file, go to Properties > Security > Edit
and give your user Modify permission.

### UAC limitations

Due to limitations caused by UAC, cancelling out of the UAC prompt will not cause any
visible errors, however the ```hosts``` file will not be updated.

### Important: Windows Users only - setup base environment

Warning: [tl;dr] (please read all lines)
Windows systems lack inbuilt Unix tools and command shells like bash/zsh shell.
To simulate such an environment on Windows we have to install tools like [Cygwin].
We use [Babun] build on top of Cygwin as it provides additional benefits.
We use [Chocolatey] as the package manager, similar to yum (on CentOS) or apt-get on (Ubuntu).

Open a (windows) command prompt with Administrator privileges (right click to see Administrator option)
Navigate to _Workspace\ck\dev.box_ folder, run win_setup.bat script to install Chocolatey and Babun.

Babun asks the user to enter 'y' to confirm the installation and waits for 30 seconds.
If the user does not confirm by entering 'y' and pressing enter, it aborts.
```sh
cd scripts
.\win_setup.bat
cd ..
```
By default Babun is installed at _C:\Users\joe\\.babun_ folder (for user Joe).
We need to move our Workspace folder under the Babun installation.
Navigate to _C:\Users\joe_ and execute (replace joe with your login id)
```sh
move Workspace _C:\Users\joe\.babun\cygwin\home\joe_
```
Close the (windows) command prompt.

Next we must verify that Babun is working properly.
The installation creates a desktop shortcut on the windows desktop.
Right-click on the shortcut and select 'Run as administrator', choose Yes for the security dialog.

If you see an error message (see below) you can ignore it for now
/usr/bin/id: cannot find name for group ID 10513

At the _{ ~ }  »_ prompt type _babun check_ and press  enter, output should look like:
```sh
babun check
Source consistent [OK]
Prompt speed      [OK]
File permissions  [OK]
Connection check  [OK]
Update check      [OK]
Cygwin check      [OK]
```

Next (in the Babun shell) list and verify the Workspace folder exists
```sh
ls
```
The _dos2unix_ command helps to convert line encoding in shell scripts to Unix format.

Additional Steps For Windows:
* [Windows Tips]
* [ConEmu & Babun Integration]

### Install BATS - Bash Automated Testing System
[Windows Users: Use Babun console opened with Administrator access]
BATS is used to verify that all required components are installed
```sh
cd bats
dos2unix ./install.sh
./install.sh /usr/local
cd ..
```

### Setup Playbook
_TBD_

### Install Ansible & Base Environment (including gcc, openssl, python etc)
[Windows Users: Use Babun console opened with Administrator access]
```sh
scripts/setup_ansible.sh
```

### Provision or Configure the Vagrant : Vagrant way
```sh
vagrant up
vagrant provision # For Full Setup
```

### Provision or Configure the Vagrant : Ansible way (preferred)
Check Ansible Installation
```sh
vagrant up
ansible -i ansible/inventory/vagrant.py -m ping all
ansible -i ansible/inventory/vagrant.py -m setup all
ansible all -i ansible/inventory/vagrant.py  -m shell -a 'hostname'
```


## Reference Shortcuts
```sh
mkdir -p roles/{monit,nginx}/{defaults,files,handlers,meta,tasks,templates,vars}
ansible-vault encrypt provision/setup/files/b2b.conf --vault-password-file ./.vault_pass
ansible-vault decrypt provision/setup/files/b2b.conf --vault-password-file ./.vault_pass
ansible-playbook -i local_inventory ansible/playbooks/laptop.setup.playbook.yml --check
VBoxManage list vms
```

[Ember.js]: http://emberjs.com/
[Oracle Virtual Box]: https://www.virtualbox.org/wiki/Downloads
[Virtual Box Ext]: https://www.virtualbox.org/wiki/Downloads
[Hashicorp Vagrant]: https://www.vagrantup.com/downloads.html
[JDK]: http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
[Maven]: https://maven.apache.org/download.cgi
[Git CLI Client]: https://git-scm.com/downloads
[NVM]: https://github.com/creationix/nvm
[Node.js]: https://nodejs.org/en/
[Eclipse]: https://www.eclipse.org
[IntelliJ]: https://www.jetbrains.com/idea
[tl;dr]: https://en.wiktionary.org/wiki/TLDR
[ansible]: http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip
[ConEmu & Babun Integration]: http://babun.github.io/faq.html#_how_do_i_integrate_babun_with_conemu_cmder
[Windows Tips]: https://github.com/rajasoun/dev.box/wiki/Test-Drive-Windows
[Cygwin]: https://www.cygwin.com/
[Babun]: http://babun.github.io/
[Chocolatey]: https://chocolatey.org/
