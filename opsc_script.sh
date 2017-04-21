#!/bin/bash

#set timezone
echo "Set timezone......."
cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
sleep 3
timedatectl | grep Timezone

# configure repositories
add-apt-repository ppa:webupd8team/java 
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -
echo "deb http://login:passwd@debian.datastax.com/enterprise stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list

apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
# install OpsCenter and a few base packages
apt-get install oracle-java8-installer oracle-java8-set-default opscenter -y

# start OpsCenter
service opscenterd start

echo "Vagrant provisioning complete and OpsCenter started"
