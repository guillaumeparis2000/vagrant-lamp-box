#!/bin/sh
version='0.0.2'
vagrantPath="/tmp/vagrant-lamp-box-$version/vagrant"
modulePath="$vagrantPath/modules"
defaultPath="$vagrantPath/manifests/default.pp"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

set -e

exist() {
  which "$1" >/dev/null 2>&1
}

if ! exist puppet; then
  echo "Install puppet"
  apt-get update
  apt-get -y install puppet
fi

if ! exist make; then
  echo "Install build-essential"
  apt-get update
  apt-get -y install build-essential
fi

if ! exist gem; then
  echo "Install rubygems1.8"
  apt-get update
  apt-get -y install rubygems1.8
fi

if ! exist librarian-puppet; then
  echo "Install librarian-puppet"
  gem install librarian-puppet
fi


# provision puppet
echo "Install modules"
cd $vagrantPath && librarian-puppet install
echo "Provision puppet"
puppet apply --pluginsync --verbose --debug --modulepath $modulePath $defaultPath
