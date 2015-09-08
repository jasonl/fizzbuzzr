require 'vagrant-hostmanager'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
    vb.memory = 512
    vb.cpus = 2

    vb.auto_nat_dns_proxy = false
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off" ]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off" ]
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "fizz1" do |web|
    web.vm.hostname = "fizz1.local"
    web.vm.network :private_network, ip: "10.30.1.11"
    web.vm.synced_folder "/Users/jason/Code/fizzbuzzr", "/opt/fizzbuzzr"
  end

  config.vm.define "fizz2" do |web|
    web.vm.hostname = "fizz2.local"
    web.vm.network :private_network, ip: "10.30.1.12"
    web.vm.synced_folder "/Users/jason/Code/fizzbuzzr", "/opt/fizzbuzzr"
  end

  config.vm.define "buzz1" do |web|
    web.vm.hostname = "buzz1.local"
    web.vm.network :private_network, ip: "10.30.1.13"
    web.vm.synced_folder "/Users/jason/Code/fizzbuzzr", "/opt/fizzbuzzr"
  end

  config.vm.define "buzz2" do |web|
    web.vm.hostname = "buzz2.local"
    web.vm.network :private_network, ip: "10.30.1.14"
    web.vm.synced_folder "/Users/jason/Code/fizzbuzzr", "/opt/fizzbuzzr"

    web.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "/Users/jason/Code/fizzbuzzr/ansible/inventory.ini"
      ansible.playbook = "/Users/jason/Code/fizzbuzzr/ansible/site.yml"
      ansible.limit = 'all'
    end
  end
end
