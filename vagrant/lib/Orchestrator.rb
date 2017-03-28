module Orchestrator
  def self.installPlugins
    required_plugins = %w(vagrant-vbguest)
    #ToDo: Temporary Fix (Explore Better Host Updater )
    if Vagrant::Util::Platform.windows? then
      winHostsFileUpdateCheck
      runDosToUnixOnShellFiles
    else # Non Windows - Add Automatic Host Updater
      required_plugins = required_plugins.push("vagrant-hostsupdater")
    end
    required_plugins.each do |plugin|
      system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end
  end

  def self.winHostsFileUpdateCheck
    controllerAddedToHosts = false
    vagrantAddedToHosts = false
    File.open 'C:\\Windows\\System32\\drivers\\etc\\hosts', mode="r" do |file|
      file.find do |line|
        if line =~ /^192\.168\.24.\d{1,3}\ +controller\.dev/ then
          controllerAddedToHosts = true
          puts  controllerAddedToHosts ##ToDo: Technical Debt
        end
        if line =~ /^192\.168\.24.\d{1,3}\ +vagrant-vm\.dev/ then
          vagrantAddedToHosts = true
          puts  controllerAddedToHosts ##ToDo: Technical Debt
        end
      end
    end

    if (!controllerAddedToHosts || !vagrantAddedToHosts)
      messageToWindowsUsers
    end
  end

  def self.runDosToUnixOnShellFiles
    # testList = %x[find . -type f -name '*.sh' -exec dos2unix -ic {} \;]
    scriptList = `find . -type f -name '*.sh' -exec dos2unix -ic {} \;`
    scriptList.each_line do |line|
      eval "%x(dos2unix -s #{line})"
    end
  end



  def self.createVM(os, auto_update, config)
    config.vm.box = os
    config.vbguest.auto_update = auto_update
    config.ssh.insert_key = false
    config.ssh.private_key_path = ['vagrant/keys/private']
    config.vm.provision 'file', source: 'vagrant/keys/public', destination: '~/.ssh/authorized_keys'
  end

  def self.configureVM(name, ip, hostname,playbook, config)
    config.vm.define name do |instance|
      instance.vm.hostname = hostname
      instance.vm.network :private_network, ip: ip
      instance.vm.provider :virtualbox do |node|
        node.name = name
        node.gui = false
        node.linked_clone = true # Speed up machine startup by using linked clones
        node.memory = 2048
        node.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        node.customize ['modifyvm', :id, '--usb', 'off']
      end

      #Configure with ansible only through controller vm for the all the vms at once
      #Coding By Convention than via Configuration
      case name
        when 'controller'
          provisionVM playbook, instance
      end
    end
  end

  def self.syncFolders(syncFolders,config)
    config.vm.synced_folder '.', '/vagrant', disabled: true # Disable shared folders
    config.vm.synced_folder 'secrets', '/secrets', mount_options: ['dmode=0755,fmode=0644']
    config.vm.synced_folder 'vagrant/keys', '/keys', mount_options: ['dmode=755,fmode=0400']
    if syncFolders
        syncFolders.each do |syncFolder|
          config.vm.synced_folder syncFolder['host'], syncFolder['guest']
        end
    end  
  end

  def self.provisionVM(playbook, instance)
    instance.vm.provision 'ansible_local' do |ansible|
      ansible.limit = 'all'
      ansible.verbose = 'v'
      ansible.install = true
      ansible.install_mode = 'default'
      ansible.version = '2.2'
      ansible.playbook = playbook
      ansible.provisioning_path = '/ck/jumpstart'
      ansible.tmp_path = '/tmp/vagrant/ansible'
      ansible.raw_arguments  = '--vault-password-file=/secrets/.vault_pass'
      ansible.inventory_path = 'ansible/inventory/topology' # "ansible/inventory/vagrant.py"
    end
  end

  def self.messageToWindowsUsers
    puts '++++++++++++++++++++ ++++++++++++++++++++ ++++++++++++++++++++'
    puts 'On Windows platform:'
    puts '- ensure C:\Windows\system32\drivers\etc\hosts has following entries'
    puts '  (you need to edit the file as Admin user to add the entries)'
    puts '   192.168.24.101  vagrant-vm.dev'
    puts '   192.168.24.100  controller.dev'
    puts '++++++++++++++++++++ ++++++++++++++++++++ ++++++++++++++++++++'
  end
end
