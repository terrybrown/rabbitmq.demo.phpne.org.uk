<?php
require_once __DIR__ . '/../vendor/autoload.php';

$container = new Pimple\Container;

$container['rabbitmq.host'] = 'localhost';
$container['rabbitmq.port'] = 5672;
$container['rabbitmq.user'] = 'guest';
$container['rabbitmq.pass'] = 'guest';
$container['rabbitmq.vhost'] = 'rabbitmq.demo.phpne.org.uk';

$container['rabbitmq'] = $container->factory(function ($container) {
    return new PhpAmqpLib\Connection\AMQPConnection(
        $container['rabbitmq.host'],
        $container['rabbitmq.port'],
        $container['rabbitmq.user'],
        $container['rabbitmq.pass'],
        $container['rabbitmq.vhost']
    );
});

$container['log'] = function ($container) {
    return new PHPNE\Demo\Service\AmqpLogService('web', $container['rabbitmq']);
};

$container['console.command.log.generate'] = function ($container) {
    return new PHPNE\Demo\Console\Command\LogGenerate('log:generate', $container['log']);
};

return $container;
