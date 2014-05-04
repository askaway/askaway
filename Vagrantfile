# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu-1310-x64-virtualbox-puppet'
  config.vm.box_url  = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box'
  config.vm.hostname = 'askaway-dev-box'
  config.vm.network "private_network", ip: "192.168.33.201"
  config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => true
  config.vm.network "forwarded_port", guest: 22, host: 3022
  config.ssh.port = 3022

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--name", "askaway"]
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    virtualbox.customize ["modifyvm", :id, "--memory", "1024"]
    virtualbox.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end


  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
  end
end
