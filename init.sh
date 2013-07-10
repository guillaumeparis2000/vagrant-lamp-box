#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

set -e

exist() {
  which "$1" >/dev/null 2>&1
}

if ! exist make; then
  echo "Install build-essential"
  apt-get update
  apt-get install build-essential
fi

if ! exist gem; then
  echo "Install rubygems1.8"
  apt-get update
  apt-get install rubygems1.8
fi

if ! exist librarian-puppet; then
  echo "Install librarian-puppet"
  gem install librarian-puppet
fi

if ! exist puppet; then
  echo "Install puppet"
  cd /tmp
  wget http://apt.puppetlabs.com/puppetlabs-release-raring.deb
  dpkg -i puppetlabs-release-raring.deb
  apt-get update
fi

# provision puppet
echo "Install modules"
cd /tmp/vagrant-lamp-box/vagrant && librarian-puppet install
echo "Provision puppet"
puppet apply --pluginsync --verbose --debug --modulepath '/tmp/vagrant-lamp-box/vagrant/modules' /tmp/vagrant-lamp-box/vagrant/manifests/default.pp
