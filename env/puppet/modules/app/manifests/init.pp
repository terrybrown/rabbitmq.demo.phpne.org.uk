class app {

    include rabbitmq
    
    exec { 'create vhost':
        command => 'rabbitmqadmin declare vhost name=rabbitmq.demo.phpne.org.uk',
        require => [Package['rabbitmq-server'], File['/usr/local/bin/rabbitmqadmin']]
    }
    
    exec { 'vhost permissions':
        command => 'rabbitmqadmin declare permission vhost=rabbitmq.demo.phpne.org.uk user=guest configure=".*" read=".*" write=".*"',
        require => Exec['create vhost']
    }

    exec { 'create exchange E01':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare exchange name=E01 type=topic auto_delete=false durable=true',
        require => Exec['vhost permissions']
    }

    exec { 'create exchange E02':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare exchange name=E02 type=topic auto_delete=false durable=true',
        require => Exec['vhost permissions']
    }

    exec { 'create E01/E02 binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E01 destination_type=exchange destination=E02 routing_key=*.web',
        require => [Exec['create exchange E01'], Exec['create exchange E02']]
    }
    
    # Web App Dev Notifications
    exec { 'create queue Q01':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare queue name=Q01 auto_delete=false durable=true',
        require => Exec['vhost permissions']
    }
    
    exec { 'create E02/Q01 erro.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q01 routing_key=erro.web',
        require => [Exec['create exchange E02'], Exec['create queue Q01']]
    }
    
    exec { 'create E02/Q01 crit.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q01 routing_key=crit.web',
        require => [Exec['create exchange E02'], Exec['create queue Q01']]
    }
    
    exec { 'create E02/Q01 aler.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q01 routing_key=aler.web',
        require => [Exec['create exchange E02'], Exec['create queue Q01']]
    }
    
    exec { 'create E02/Q01 emer.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q01 routing_key=emer.web',
        require => [Exec['create exchange E02'], Exec['create queue Q01']]
    }
    
    # Web App Ops Notifications
    exec { 'create queue Q02':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare queue name=Q02 auto_delete=false durable=true',
        require => Exec['vhost permissions']
    }
    
    exec { 'create E02/Q02 aler.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q02 routing_key=aler.web',
        require => [Exec['create exchange E02'], Exec['create queue Q02']]
    }
    
    exec { 'create E02/Q02 emer.web binding':
        command => 'rabbitmqadmin --vhost=rabbitmq.demo.phpne.org.uk declare binding source=E02 destination=Q02 routing_key=emer.web',
        require => [Exec['create exchange E02'], Exec['create queue Q02']]
    }
}