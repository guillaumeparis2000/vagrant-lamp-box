# == Define: package
#
# This class install application through apt
#
# === Parameters
#
# Document parameters here
#
# [*name*]
#   Name of the application to insyall
#
# === Examples
#
# Provide some examples on how to use this type:
#   system::package { "vim": }
#
define system::package (
  $ensure = 'present') {
  include system

  package {
    "Tools_${name}":
        ensure  => $ensure,
        name    => $name,
        require => Exec['apt-update'],
    }
}
