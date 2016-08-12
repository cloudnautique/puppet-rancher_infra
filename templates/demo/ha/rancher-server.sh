#/bin/bash

set -eux

exec > /tmp/provisioning.log
exec 2>&1

apt-get update
apt-get install -y puppet
puppet resource service puppet enable=false ensure=stopped
puppet module install garethr/docker
puppet apply -e 'include ::docker'
docker pull rancher/<%= @rancher_version %>
