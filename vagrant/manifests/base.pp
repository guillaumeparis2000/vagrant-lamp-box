file { "/etc/apt/sources.list.d/squeeze-backports.list":
    ensure  => file,
    owner   => root,
    group   => root,
    content => "deb http://backports.debian.org/debian-backports squeeze-backports main",
}


exec { "import-gpg":
    command => "/usr/bin/wget -q http://www.dotdeb.org/dotdeb.gpg -O -| /usr/bin/apt-key add -"
}

exec { "/usr/bin/apt-get update":
    require => [File["/etc/apt/sources.list.d/squeeze-backports.list"], Exec["import-gpg"]],
}



class { "system": }

file { "/etc/motd":
    ensure  => file,
    mode    => "0644",
    owner   => "root",
    group   => "root",
    content => template("system/motd.erb"),
}

            system::package { "build-essential": }
                system::package { "curl": }
                system::package { "git-core": }
                system::package { "vim": }
                system::package { "htop": }
        system::package { "atop": }
                system::package { "sendmail-bin": }

system::config { "bashrc":
    name   => ".bashrc",
    source => "/vagrant/files/system/bashrc",
}


class { "apache": }

class { "apache::mod::php":
    require => Package["php5"]
}

class { "apache::mod::ssl": }

apache::mod { "rewrite": }
apache::mod { "headers": }

apache::vhost { "dev-lamp":
    priority    => "50",
    vhost_name  => "*",
    port        => "80",
    docroot     => "/var/www/vhosts/dev-lamp/",
    serveradmin => "admin@dev-lamp",
    template    => "system/apache-default-vhost.erb",
    override    => "All",
}

file { "phpmyadmin-vhost-creation":
    path    => "/etc/apache2/sites-enabled/phpmyadmin.conf",
    ensure  => "/vagrant/files/apache/sites-enabled/phpmyadmin.conf",
    require => [Package["php5"], Package["apache2"]],
    owner   => "root",
    group   => "root",
}


class { "mysql":
    root_password => "root",
    require       => Exec["apt-update"],
}


class { "php": }

file { "php5-ini-apache2-config":
    path    => "/etc/php5/apache2/php.ini",
    ensure  => "/vagrant/files/php/php.ini",
    require => Package["php5"],
}

file { "php5-ini-cli-config":
    path    => "/etc/php5/cli/php.ini",
    ensure  => "/vagrant/files/php/php-cli.ini",
    require => Package["php5"],
}

php::module { "common": }
php::module { "dev": }

    php::module { "mysql": }
    php::module { "intl": }
    php::module { "cli": }
    php::module { "imagick": }
    php::module { "gd": }
    php::module { "mcrypt": }
    php::module { "curl": }
    php::module { "apc":
      module_prefix => "php-",
    }


system::package { "phpmyadmin":
    require => Package["php5"]
}


vcsrepo { "vim-config":
    path     => "/home/vagrant/.vim-config",
    ensure   => present,
    provider => git,
    source   => "https://github.com/stephpy/vim-config.git",
    require  => Package["vim"],
    user     => "vagrant",
    group    => "vagrant",
}

file { "vim-config-symlink-vimdir":
    path    => "/home/vagrant/.vim/",
    ensure  => link,
    target  => "/home/vagrant/.vim-config/.vim/",
    require => Vcsrepo["vim-config"],
    owner   => "vagrant",
    replace => false,
}

file { "vim-config-symlink-vimrcfile":
    path    => "/home/vagrant/.vimrc",
    ensure  => link,
    target  => "/home/vagrant/.vim-config/.vimrc",
    require => Vcsrepo["vim-config"],
    owner   => "vagrant",
    replace => false,
}

file { "vim-vimrc-local-after":
    path    => "/home/vagrant/.vimrc.local.after",
    ensure  => "/vagrant/files/vimrc.local.after",
    require => Vcsrepo["vim-config"],
}

# exec { "vim-make-command-t":
#     command => "rake make",
#     cwd     => "/home/vagrant/.vim/bundle/Command-T",
#     unless  => "ls -aFlh /home/vagrant/.vim/bundle/Command-T|grep 'command-t.recipe'",
#     require => Vcsrepo["vim-config-vundle"]
# }


system::package { "zsh": }

exec { "oh-my-zsh-install":
    command => "git clone https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh",
    path    => "/bin:/usr/bin",
    require => Package["zsh"],
}

exec { "default-zsh-shell":
    command => "chsh -s /usr/bin/zsh vagrant",
    unless  => "grep -E \"^vagrant.+:/usr/bin/zsh$\" /etc/passwd",
    require => Package["zsh"],
    path    => "/bin:/usr/bin",
}

file { "zshrc-file-creation":
    path    => "/home/vagrant/.zshrc",
    ensure  => "/vagrant/files/.zshrc",
    require => Exec["oh-my-zsh-install"],
    owner   => "vagrant",
    group   => "vagrant",
    replace => false,
}


