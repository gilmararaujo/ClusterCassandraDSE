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
apt-get install oracle-java8-installer oracle-java8-set-default dse-full -y


# copy config files and restart Cassandra
IP=`/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
sed -i -e "s/^\s*cluster_name:.*$/cluster_name: 'Cluster Vagrant'/" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^.*num_tokens:.*$/num_tokens: 256/" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/ seeds:.*$/ seeds: 'DSE1,DSE2'/" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^listen_address:.*$/listen_address: $IP/" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^.*broadcast_address:.*$/broadcast_address: /" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^rpc_address:.*$/rpc_address: 0.0.0.0/" //etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^.*broadcast_rpc_address:.*$/broadcast_rpc_address: $IP/" /etc/dse/cassandra/cassandra.yaml
sed -i -e "s/^endpoint_snitch:.*$/endpoint_snitch: PropertyFileSnitch/" /etc/dse/cassandra/cassandra.yaml

sleep 3
echo "Restarting Cassandra..."
service dse start

echo "Vagrant provisioning complete!!!"
