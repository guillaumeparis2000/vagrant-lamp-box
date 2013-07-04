node 'dev-lamp' {
  $user = 'portal'
  $userFullname = "Portal User"

  class { 'timezone': timezone => 'Europe/Madrid', }

  class { 'system': }

  class { 'user':
      userName => $user,
      shell => 'zsh',
  }


  file { '/etc/motd':
      ensure  => file,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('system/motd.erb'),
  }

              system::package { 'build-essential': }
                  system::package { 'curl': }
                  system::package { 'git-core': }
                  system::package { 'vim': }
                  system::package { 'htop': }
          system::package { 'atop': }
                  system::package { 'sendmail-bin': }


  class { 'apache': }

  class { 'apache::mod::php':
      require => Package['php5']
  }

  class { 'apache::mod::ssl': }

  apache::mod { 'rewrite': }
  apache::mod { 'headers': }

  $apacheUser  = $apache::params::user
  $apacheGroup = $apache::params::group

  apache::vhost { 'dev-lamp':
      priority        => '50',
      vhost_name      => '*',
      port            => '80',
      docroot         => '/var/www/vhost/',
      docroot_owner   => $apacheUser,
      docroot_group   => $apacheGroup,
      serveradmin     => 'admin@dev-lamp',
      template        => 'system/apache-default-vhost.erb',
      override        => 'All',
      require         =>  File['www'],
  }

  file { 'www':
      ensure  => directory,
      target  => '/var/www',
      path    => '/var/www',
      require => Package['apache2'],
      owner   => 'root',
      group   => 'root',
  }


  file { 'phpmyadmin-vhost-creation':
      ensure  => link,
      target  => '/vagrant/files/apache/sites-enabled/phpmyadmin.conf',
      path    => '/etc/apache2/sites-enabled/phpmyadmin.conf',
      require => [Package['php5'], Package['apache2']],
      owner   => 'root',
      group   => 'root',
  }


  class { 'mysql':
      root_password => 'root',
      require       => Exec['apt-update'],
  }


  class { 'php': }

  file { 'php5-ini-apache2-config':
      ensure  => link,
      target  => '/vagrant/files/php/php.ini',
      path    => '/etc/php5/apache2/php.ini',
      require => Package['php5'],
  }

  file { 'php5-ini-cli-config':
      ensure  => link,
      target  => '/vagrant/files/php/php-cli.ini',
      path    => '/etc/php5/cli/php.ini',
      require => Package['php5'],
  }

  php::module { 'common': }
  php::module { 'dev': }

      php::module { 'mysql': }
      php::module { 'intl': }
      php::module { 'cli': }
      php::module { 'imagick': }
      php::module { 'gd': }
      php::module { 'mcrypt': }
      php::module { 'curl': }
      php::module { 'apc':
        module_prefix => 'php-',
      }


  system::package { 'phpmyadmin':
      require => Package['php5']
  }
}
