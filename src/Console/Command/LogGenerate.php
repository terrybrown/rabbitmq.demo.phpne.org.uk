<?php
namespace PHPNE\Demo\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

use Monolog\Logger;
use PHPNE\Demo\Service\AmqpLogService;

class LogGenerate extends Command
{
    const DEFAULT_ENTRY_COUNT = 1000;
    const MAX_ENTRY_COUNT = 100000;

    protected $logger = null;

    public function __construct($name = null, AmqpLogService $logger)
    {
        parent::__construct($name);

        $this->logger = $logger;
    }

    protected function configure()
    {
        $this
            ->setDescription('Generate random log entries of differing log levels')
            ->addArgument(
                'exchange',
                InputArgument::REQUIRED,
                'Which Exchange would you like to send the messages to?'
            )
            ->addArgument(
                'entries',
                InputArgument::OPTIONAL,
                'How many log entries would you like to generate?',
                self::DEFAULT_ENTRY_COUNT
            )
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $entries = min((int) $input->getArgument('entries'), self::MAX_ENTRY_COUNT);
        
        for ($entry = 1; $entry <= $entries; $entry++) {

            list($level, $message) = $this->createRandomLogEntry();

            $this->logger->log($input->getArgument('exchange'), $level, $message);

            $output->writeln(sprintf('#%06d <info>%s</info> %s', $entry, Logger::getLevelName($level), $message));
        }
    }

    private function createRandomLogEntry()
    {
        $levels = [
            Logger::DEBUG,
            Logger::INFO,
            Logger::NOTICE,
            Logger::WARNING,
            Logger::ERROR,
            Logger::CRITICAL,
            Logger::ALERT,
            Logger::EMERGENCY,
        ];

        return [
            $levels[ array_rand($levels) ],
            'This is a dummy log entry for demonstration purposes, please ignore',
        ];
    }
}
