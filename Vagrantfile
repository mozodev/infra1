# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.name = 'drupal 8'
    vb.memory = 512
  end

  config.vm.provision "ansible" do |a|
    system( "ansible-gallaxy install geerlingguy.drupal" )
    a.playbook = 'playbook.yml'
    a.verbose = 'v'
    a.host_key_checking = false
  end

end
