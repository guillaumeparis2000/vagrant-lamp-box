# Class: user::params
#
# This class manages User parameters
#
# Parameters:
# - The $userName that that will be created
# - The $group the groups that the user will have
# - The $managehome this will create the home diectory
# - The $shell shell that the user will user (bash, zsh)
# - The $comment Comment applyed during the user creation
# - The $ensure state of the object (present, absent, role)
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class user::params {

  $managehome = true
  $shell      = 'bash'
  $comment    = 'This user was created by Puppet'
  $ensure     = present

}
