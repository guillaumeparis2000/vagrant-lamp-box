# == Define: package
#
# This class allow to create system configuration files
#
# === Parameters
#
# [*name*]
#   name of the configuration file
#
# [*source*]
#   Source file to create the configuration file
#
# === Examples
#
# Provide some examples on how to use this type:
#   system::config { "bashrc":
#       name   => ".bashrc",
#      source => "/vagrant/files/system/bashrc",
#  }
#
define system::config ($source, $ensure = 'present') {
  file {
        "System_${name}":
        ensure  => $ensure,
        name    => "/home/vagrant/${name}",
        source  => $source,
    }
}
