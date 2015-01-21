<?php
namespace PHPNE\Demo\Service;

use Monolog\Logger;
use Monolog\Handler\AmqpHandler;
use PhpAmqpLib\Connection\AMQPConnection;

class AmqpLogService
{
    protected $name = null;
    protected $connection = null;

    public function __construct($name, AMQPConnection $connection)
    {
        $this->name= $name;
        $this->connection = $connection;
    }

    public function log($exchange, $level, $message, array $context = [])
    {
        $log = new Logger($this->name);
        $log->pushHandler(new AmqpHandler($this->connection->channel(), $exchange));
        $log->addRecord($level, $message, $context);
    }
}
