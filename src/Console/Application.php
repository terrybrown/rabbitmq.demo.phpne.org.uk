<?php
namespace PHPNE\Demo\Console;

use Symfony\Component\Console\Application as Console;

class Application extends Console
{
    const NAME = 'PHPNE RabbitMQ Demo';
    const VERSION = '0.0.1';

    public function __construct($name = self::NAME, $version = self::VERSION)
    {
        parent::__construct($name, $version);
    }
}
