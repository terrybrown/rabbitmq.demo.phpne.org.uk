class php::composer {

    include php

    exec { 'download composer':
        command => 'wget --quiet --trust-server-names --directory-prefix /usr/src --timestamping http://getcomposer.org/composer.phar',
        require => Package['php5-cli']
    }

    exec { 'install composer':
        command => 'cp /usr/src/composer.phar /usr/local/bin/composer',
        require => Exec['download composer']
    }

    exec { 'make composer executable':
        command => 'chmod a+x /usr/local/bin/composer',
        require => Exec['install composer']
    }

    exec { 'update composer':
        command => '/usr/local/bin/composer self-update',
        environment => ["COMPOSER_HOME=/usr/local/bin/"],
        require => Exec['make composer executable']
    }
}