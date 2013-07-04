# == Define: package
#
# This class allow to create configuration files for the user
#
# === Parameters
#
# [*name*]
#   name of the configuration file
#
# [*user*]
#   User to apply the configuration
#
# [*source*]
#   Source file to create the configuration file
#
# === Examples
#
# Provide some examples on how to use this type:
#   system::config { "bashrc":
#      name   => ".bashrc",
#      source => "/vagrant/files/system/bashrc",
#  }
#
define system::config ($source, $user, $require = [], $ensure = 'present') {
  file { "System_$source":
      ensure  => $ensure,
      name    => "/home/$user/$name",
      source  => "puppet:///modules/user/$source",
      require => $require,
      owner   => $user,
      group   => $user,
    }
}
