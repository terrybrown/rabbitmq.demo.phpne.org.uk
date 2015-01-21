class rabbitmq {

    package { 'rabbitmq-server':
        ensure => 'present',
        require => Exec['apt-get update']
    }
    service { 'rabbitmq-server':
        ensure => 'running',
        require => Package['rabbitmq-server']
    }
    
    file { '/etc/default/rabbitmq-server':
        ensure => present,
        owner => 'root',
        group => 'root',
        source => 'puppet:///data/modules/rabbitmq/templates/rabbitmq-server',
        require => Package['rabbitmq-server'],
        notify => Service['rabbitmq-server']
    }
    
    file { '/etc/rabbitmq/rabbitmq.config':
        ensure => present,
        owner => 'root',
        group => 'root',
        source => 'puppet:///data/modules/rabbitmq/templates/rabbitmq.config',
        require => Package['rabbitmq-server'],
        notify => Service['rabbitmq-server']
    }
    
    exec { 'rabbitmq-plugins enable rabbitmq_management':
        command => 'rabbitmq-plugins enable rabbitmq_management',
        environment => "HOME=/root",
        require => Package['rabbitmq-server'],
        notify => Service['rabbitmq-server']
    }
    
    exec { 'download rabbitmqadmin':
        command => 'curl -o /usr/local/bin/rabbitmqadmin localhost:15672/cli/rabbitmqadmin',
        creates => '/usr/local/bin/rabbitmqadmin',
        environment => "HOME=/root",
        require => [Exec['rabbitmq-plugins enable rabbitmq_management'], Package['rabbitmq-server']]
    }
    
    file { '/usr/local/bin/rabbitmqadmin':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 755,
        require => Exec['download rabbitmqadmin']
    }
    
    exec { 'rabbitmqadmin bash completion':
        command => 'rabbitmqadmin --bash-completion > /etc/bash_completion.d/rabbitmqadmin',
        creates => '/etc/bash_completion.d/rabbitmqadmin',
        environment => "HOME=/root",
        require => File['/usr/local/bin/rabbitmqadmin']
    }
}
