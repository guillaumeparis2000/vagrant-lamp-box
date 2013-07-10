vagrant-lamp-box
================

This project allow to create a virtual machine with a LAMP server installed. This project use the Web VM Generator as base code to create the virtual Machine. The modification that have been done through the VN generated by Web VM Generator are: 
  * Migration to Vagran 1.1+
  * Migration of the modules to puppet to avoid the usage of shell script to install the modules

## Prerequisites
You must have the following items installed and working

+ [VirtualBox](https://www.virtualbox.org/)
+ [Vagrant 1.1+](http://vagrantup.com/)

## Quickstart
First clone this repo into your machine
```sh
$ git clone git@github.com:guillaumeparis2000/vagrant-lamp-box.git
$ cd vagrant-lamp-box/vagrant
```

Install all required Puppet modules defined for the project using `librarian-puppet`
```sh
$ librarian-puppet install
```

Start the vms with Vagrant
```sh
$ vagrant up 
```

### Librarian-puppet
[Librarian-Puppet](https://github.com/rodjek/librarian-puppet) is an extension of ruby’s bundler model to install gems, having a file that defines your dependencies, `Gemfile` in the case of bundler, `Puppetfile` in the case of librarian, and a `.lock` file with the resolved dependencies.

The resolution model is different than those of `yum`, `apt-get` or `maven`, that resolve dependencies at every run on the client, relying on the clients to consistently do that over versions and machines. In the bundler or librarian model, resolution only happens once and it’s saved to the lock file, which is used from there on by the clients until dependencies are changed.

The librarian Puppetfile allows defining module dependencies from several sources

####Puppet Forge

Using the [forge provider](http://forge.puppetlabs.com) and module name, and optionally version it calls puppet module tool to fetch the tarball and extract it in the designed directory
```sh
mod "maestrodev/maven", "1.0.0"
```

####Git

Modules can also be cloned from a git repository optionally defining what branch, tag or revision to checkout
```pp
mod "maven",
  :git => "https://github.com/maestrodev/puppet-maven.git",
  :ref => 'v1.0.0'
```

####Path folders

Useful mostly for testing or while transitioning to a full dependency model, local paths can be used as modules
```pp
mod 'mymodule', :path => './private/mymodule'
```

Install all required Puppet modules defined for the project
```sh
$ librarian-puppet install
```

##Vagrant command-line interface
Almost all interaction with Vagrant is done through the command-line interface.

The interface is available using the `vagrant` command, and comes installed with Vagrant automatically. The vagrant command in turn has many subcommands, such as `vagrant up`, `vagrant destroy`, etc.

Start all the vms with Vagrant
```sh
$ vagrant up
```

Reload the machines
```sh
$ vagrant reload
```

Stop the machines
```sh
$ vagrant halt
```

Log on to the vms
```sh
$ vagrant ssh
```

## Installation in a clean Ubuntu 13.04 64bits (raring)
To install the vagrant-lamp-box on a clean ubuntu Raring server, you need to download the last release, untar it, edit the ```vagrant/manifests/default.pp``` manifest file to set the hostname and execute the ini.sh file.

```sh
$ wget https://github.com/guillaumeparis2000/vagrant-lamp-box/archive/
$ tar xvzf 0.0.1.tar.gz
$ cd vagrant-lamp-box-0.0.2
$ vim vagrant/manifests/default.pp  # to change the hostname (replace dev-lamp by the good one)
$ sudo ./init.sh
```
