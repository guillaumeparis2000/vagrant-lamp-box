# Class: postfix
#
# This module manages system
#
# Actions:
#   install postfix and configure it as a relay
# Requires:
#   n/a
#
# Sample usage:
#
#  class { "postfix": }
#
class postfix (
  $smtpServer   = 'smtp.gmail.com',
  $smtpPort     = '587', # Usually 25
  $smtpPassword = '',
  $smtpUser     = '',
  $hostname     = '',
  $domain       = 'localhost',
  $relayTo      = '',
  $template     = 'postfix/postfix_main.erb'
  ) {

  # Install postfix
  system::package { 'postfix': }
  system::package { 'libsasl2-2': }
  system::package { 'ca-certificates': }
  system::package { 'libsasl2-modules': }

  # define the service to restart
  service { 'postfix':
    ensure  => 'running',
    enable  => true,
    require => Package['postfix'],
  }

  # Template uses:
  # - $vhost_name
  # - $port
  # - $ssl
  # - $ssl_path
  # - $srvname
  # - $serveraliases
  # - $no_proxy_uris
  # - $dest
  # - $apache::params::apache_name
  # - $access_log
  # - $name
  file { 'main.cf':
    path    => '/etc/postfix/main.cf',
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['postfix'],
    notify  => Service['postfix'],
  }

  # Template uses:
  # - $smtpServer
  # - $smtpPort
  # - $smtpUser
  # - $smtpPassword
  file { 'sasl_passwd':
    path    => '/etc/postfix/sasl_passwd',
    content => template('postfix/sasl_passwd.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    require => Package['postfix'],
    notify  => Service['postfix'],
  }

  # Template uses:
  # - $relayTo
  file { 'virtual-regexp':
    path    => '/etc/postfix/virtual-regexp',
    content => template('postfix/virtual-regexp.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    require => Package['postfix'],
    notify  => Service['postfix'],
  }

  exec { 'postmap sasl_passwd':
    command => 'postmap /etc/postfix/sasl_passwd',
    path    => '/usr/sbin/',
    require => [Package['postfix'],File['sasl_passwd']],
    notify  => Service['postfix'],
  }

  exec { 'postmap virtual-regexp':
    command => 'postmap /etc/postfix/virtual-regexp',
    path    => '/usr/sbin/',
    onlyif  => ['/usr/bin/test -f /etc/postfix/virtual-regexp'],
    require => Package['postfix'],
  }

  # Copy Equifax_Secure_CA.pem and Thawte_Premium_Server_CA.pem to
  # /etc/postfix/ssl
  file { '/etc/postfix/ssl':
    ensure  => directory, # so make this a directory
    owner   => 'root',
    group   =>'root',
    replace => false,
    require => Package['postfix'],
  }

  file { '/etc/postfix/ssl/Equifax_Secure_CA.pem':
    ensure  => file,
    source  => '/etc/ssl/certs/Equifax_Secure_CA.pem',
    owner   => 'root',
    group   =>'root',
    replace => false,
    require => File['/etc/postfix/ssl'],
  }

  file { '/etc/postfix/ssl/Thawte_Premium_Server_CA.pem':
    ensure  => file,
    source  => '/etc/ssl/certs/Thawte_Premium_Server_CA.pem',
    owner   => 'root',
    group   =>'root',
    replace => false,
    require => File['/etc/postfix/ssl/Equifax_Secure_CA.pem'],
  }

  exec { 'copy_certs1':
    command => 'cat /etc/postfix/ssl/Equifax_Secure_CA.pem \
                >> /etc/postfix/ssl/cacert.pem && \
                echo >> /etc/postfix/ssl/cacert.pem',
    path    => '/bin/',
    notify  => Service['postfix'],
    require => File['/etc/postfix/ssl/Thawte_Premium_Server_CA.pem'],
  }

  exec { 'copy_certs2':
    command => 'cat /etc/postfix/ssl/Thawte_Premium_Server_CA.pem \
                >> /etc/postfix/ssl/cacert.pem',
    path    => '/bin/',
    notify  => Service['postfix'],
    require => Exec['copy_certs1'],
  }
}
