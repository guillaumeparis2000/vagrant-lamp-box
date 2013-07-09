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
define system::config ($source, $target, $required, $ensure = 'present') {

  file { "Systen_${name}":
      ensure  => $ensure,
      source  => "puppet:///modules/system/${source}",
      name    => $target,
      require => $required,
      owner   => 'root',
      group   => 'root',
  }
}
