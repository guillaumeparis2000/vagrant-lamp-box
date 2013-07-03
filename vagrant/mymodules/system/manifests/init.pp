# Class: system
#
# This module manages system
#
# Actions:
#   Update apt repository
# Requires:
#   n/a
#
# Sample usage:
#
#  class { "system": }
#
class system {
  exec { 'apt-update':
      command => 'apt-get update',
      path    => '/usr/bin/',
  }
}
