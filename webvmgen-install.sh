#!/usr/bin/env bash

BASE_SCRIPT_DIR="$PWD"
BASE_VAGRANT_DIR="$PWD/vagrant"

clear

echo -e ""
echo -e "\033[32m  _/      _/  _/      _/\033[0m   WebVMGenerator"
echo -e "\033[32m _/      _/  _/_/  _/_/ \033[0m   "
echo -e "\033[32m_/      _/  _/  _/  _/  \033[0m   Generator service to make your"
echo -e "\033[32m _/  _/    _/      _/   \033[0m   Vagrant + Puppet web Virtual Machines easily."
echo -e "\033[32m  _/      _/      _/    \033[0m   "
echo ""
echo "By Cédric Dugat <cedric@dugat.me>"
echo "Website: http://vmg.slynett.com"
echo "GitHub repository: http://github.com/Ph3nol/WebVMGenerator"
echo ""
echo ""

echo -e "\033[33m-----------------------------------------\033[0m"
echo ""
echo -e "\033[33m        INSTALLATION IN PROGRESS...      \033[0m"
echo ""
echo -e "\033[33m-----------------------------------------\033[0m"
echo ""
echo ""

echo -e "\033[33m--> Grabbing generated Vagrant configuration...\033[0m"
echo ""
wget --no-check-certificate http://vmg.slynett.com/download/533ef7ab24923b71fc0c46189598f6b8.tar -O $BASE_SCRIPT_DIR/533ef7ab24923b71fc0c46189598f6b8.tar
echo ""

echo -e "\033[33m--> Uncompacting downloaded archive...\033[0m"
echo ""
tar xf $BASE_SCRIPT_DIR/533ef7ab24923b71fc0c46189598f6b8.tar
mv $BASE_SCRIPT_DIR/533ef7ab24923b71fc0c46189598f6b8 $BASE_VAGRANT_DIR
echo "Done."
echo ""

echo -e "\033[33m--> Grabbing 8 Git dependencie(s)...\033[0m"
echo ""
git clone https://github.com/example42/puppi.git $BASE_VAGRANT_DIR/modules/puppi
git clone https://github.com/puppetlabs/puppetlabs-stdlib.git $BASE_VAGRANT_DIR/modules/stdlib
git clone https://github.com/puppetlabs/puppetlabs-vcsrepo.git $BASE_VAGRANT_DIR/modules/vcsrepo
git clone https://github.com/puppetlabs/puppetlabs-apt.git $BASE_VAGRANT_DIR/modules/apt
git clone https://github.com/puppetlabs/puppetlabs-firewall.git $BASE_VAGRANT_DIR/modules/firewall
git clone https://github.com/puppetlabs/puppetlabs-apache.git $BASE_VAGRANT_DIR/modules/apache
git clone https://github.com/example42/puppet-mysql.git $BASE_VAGRANT_DIR/modules/mysql
git clone https://github.com/example42/puppet-php.git $BASE_VAGRANT_DIR/modules/php
git clone https://github.com/ripienaar/puppet-concat.git $BASE_VAGRANT_DIR/modules/concat
echo ""

echo -e "\033[33m--> Checkout apache modules to 0.6.0 version \033[0m"
echo ""
cd $BASE_VAGRANT_DIR/modules/apache
git checkout 0.6.0
echo "Done."
echo ""

echo -e "\033[33m--> Cleaning...\033[0m"
echo ""
rm $BASE_SCRIPT_DIR/533ef7ab24923b71fc0c46189598f6b8.tar
rm -rf $BASE_VAGRANT_DIR/.git*
echo "Done."
echo ""

echo -e "\033[33m--> Ready to go!\033[0m"
echo ""
echo -e "Just run \033[32mvagrant up\033[0m into your vagrant/ directory to construct your Vagrant VM, then \033[32mvagrant ssh/\033[0m to open your first Vagrant SSH session."
echo ""
