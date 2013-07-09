# Class: user
#
# This class create users
#
# Parameters:
#
# Actions:
#   - Create User
#
# Requires:
#
# Sample Usage:
#
class user (
  $userName   = '',
  $managehome = $user::params::managehome,
  $shell      = $user::params::shell,
  $comment    = $user::params::comment,
  $ensure     = $user::params::ensure,
) inherits user::params {

  case $shell {
    'zsh': {
      system::package { 'zsh': }

      user { $userName:
        ensure      => $ensure,
        comment     => $comment,
        managehome  => $managehome,
        shell       => '/bin/zsh',
        require     => [Package['zsh']],
      }


      vcsrepo { 'oh-my-zsh-install':
        ensure   => present,
        path     => "/home/${userName}/.oh-my-zsh",
        provider => git,
        source   => 'https://github.com/robbyrussell/oh-my-zsh.git',
        require  => [User[$userName]],
        owner    => $userName,
        group    => $userName,
      }

      file {
        'System_zsh':
        ensure  => present,
        name    => "/home/${userName}/.zshrc",
        source  => 'puppet:///modules/user/zshrc',
        require => [User[$userName]],
        owner   => $userName,
        group   => $userName,
      }
    }

    default: {
      user { $userName:
        ensure        => $ensure,
        comment       => $comment,
        managehome    => $managehome,
        shell         => '/bin/bash',
      }

      exec { 'chown':
        command => "chown -R ${userName}:${userName} /home/${userName}",
        path    => '/bin',
        user    => 'root',
        require => User[$userName],
      }

      file { 'System_bashrc':
        ensure  => present,
        name    => "/home/${userName}/.bashrc",
        source  => 'puppet:///modules/user/bashrc',
        require => [User[$userName]],
        owner   => $userName,
        group   => $userName,
      }
    }
  }


  vcsrepo { 'vim-config':
    ensure   => present,
    path     => "/home/${userName}/.vim-config",
    provider => git,
    source   => 'https://github.com/stephpy/vim-config.git',
    require  => [Package['vim'], User[$userName]],
    owner    => $userName,
    group    => $userName,
  }

  file { 'vim-config-symlink-vimdir':
      ensure  => link,
      path    => "/home/${userName}/.vim/",
      target  => "/home/${userName}/.vim-config/.vim/",
      require => Vcsrepo['vim-config'],
      owner   => $userName,
      group   => $userName,
      replace => false,
  }

  file { 'vim-config-symlink-vimrcfile':
      ensure  => link,
      path    => "/home/${userName}/.vimrc",
      target  => "/home/${userName}/.vim-config/.vimrc",
      require => Vcsrepo['vim-config'],
      owner   => $userName,
      group   => $userName,
      replace => false,
  }

  file { 'vim-vimrc-local-after':
      ensure  => present,
      source  => 'puppet:///modules/user/vimrc.local.after',
      name    => "/home/${userName}/.vimrc.local.after",
      require => Vcsrepo['vim-config'],
      owner   => $userName,
      group   => $userName,
  }

}
