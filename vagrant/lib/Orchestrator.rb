module Orchestrator
  def self.installPlugins
    required_plugins = %w(vagrant-vbguest vagrant-hostsupdater)
    required_plugins.each do |plugin|
      system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end
  end

  def self.createVM(os, config)
    config.vm.box = os
    config.vbguest.auto_update = true
    config.ssh.insert_key = false
    config.ssh.private_key_path = ['vagrant/keys/private']
    config.vm.provision 'file', source: 'vagrant/keys/public', destination: '~/.ssh/authorized_keys'
  end

  def self.configureVM(env, name, ip, hostname, workspace, playbook, config)
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
      case env
      when 'web'
        syncFolderForWeb workspace, instance
      when 'controller'
        provisionVM playbook, instance
      end
    end
  end

  def self.syncFolder(workspace, config)
    config.vm.synced_folder '.', '/vagrant', disabled: true # Disable shared folders
    config.vm.synced_folder workspace, '/ck', mount_options: ['dmode=0755,fmode=0644']
    config.vm.synced_folder 'secrets', '/secrets', mount_options: ['dmode=0755,fmode=0644']
    config.vm.synced_folder 'vagrant/keys', '/keys', mount_options: ['dmode=755,fmode=0400']
  end

  def self.syncFolderForWeb(ck_workspace, instance)
    host_path  = "#{ck_workspace}/knowledgecenter/kc-web/src/main/webapp"
    guest_path = '/usr/share/nginx/knowledgecenter'
    instance.vm.synced_folder host_path, guest_path
  end

  def self.provisionVM(playbook, instance)
    instance.vm.provision 'ansible_local' do |ansible|
      ansible.limit = 'all'
      ansible.verbose = 'v'
      ansible.install = true
      ansible.install_mode = 'default'
      ansible.version = '2.2'
      ansible.playbook = playbook
      ansible.provisioning_path = '/ck/testdrive'
      ansible.tmp_path = '/tmp/vagrant/ansible'
      ansible.raw_arguments  = '--vault-password-file=/secrets/.vault_pass'
      ansible.inventory_path = 'ansible/inventory/topology' # "ansible/inventory/vagrant.py"
    end
  end
end
