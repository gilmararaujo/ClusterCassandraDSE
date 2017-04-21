# -*- mode: ruby -*-
# vi: set ft=ruby :
# Set these environment variables before running `vagrant up`:
#   Optional:
#     DEB_CACHE_HOST = Debian package cache, e.g. "http://192.168.99.100:8000" (default: no cache)

# Adjustable settings
CFG_MEMSIZE = "1500"    # max memory for each VM
SERVER_COUNT = 4
NETWORK = '192.168.99.'
FIRST_IP = 120

# Configure VM servers
hosts = "127.0.0.1 localhost localhost.local\n"
servers = []
(0..SERVER_COUNT-1).each do |i|
  name = 'DSE' + i.to_s
  ip = NETWORK + (FIRST_IP + i).to_s
  servers << {'name' => name, 'ip' => ip}

  hosts << "\n" + ip + "\t" + name
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.box = "ubuntu/trusty64"
  servers.each do |server|
    config.vm.define server['name'] do |config2|
      config2.vm.hostname = server['name']

      config2.vm.network :private_network, ip: server['ip']
      config2.vm.provision "shell", inline: "echo '#{hosts}' > /etc/hosts"
      if (server['name'] == 'DSE0')
        config2.vm.provision "shell", path: "./opsc_script.sh"
      else
        config2.vm.provision "shell", path: "./node_script.sh"
      end

      config2.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"]  = CFG_MEMSIZE
      end
      config2.vm.provider :virtualbox do |v|
        v.name = server['name']
        v.customize ["modifyvm", :id, "--memory", CFG_MEMSIZE]
      end

    end
  end
end
