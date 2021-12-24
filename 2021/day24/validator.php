<?php

class ALU {
    private array $storage = [];
    private array $input   = [];
    private array $instructions = [];
    private int $pc = 0;

    function load_program(array $instructions) {
        $this->pc = 0;
        $this->instructions = $instructions;
    }

    function load_input(string $input) {
        $this->input = str_split($input);
    }

    function reset() {
        $this->pc = 0;
        $this->storage = [];
    }

    function read_variable(string $variable): int {
        return $this->storage[$variable] ?? 0;
    }

    function inp(string $variable) {
        $this->storage[$variable] = array_shift($this->input);
    }

    function add(string $variable, int $input) {
        $this->storage[$variable] = $this->read_variable($variable) + $input;
    }

    function mul(string $variable, int $input) {
        $this->storage[$variable] = $this->read_variable($variable) * $input;
    }

    function div(string $variable, int $input) {
        $this->storage[$variable] = floor($this->read_variable($variable) / $input);
    }

    function mod(string $variable, int $input) {
        $this->storage[$variable] = $this->read_variable($variable) % $input;
    }

    function eql(string $variable, int $input) {
        $this->storage[$variable] = $this->read_variable($variable) === $input ? 1 : 0;
    }

    function read_instruction(): bool {
        $instruction = explode(" ", $this->instructions[$this->pc]);
        $operation = $instruction[0];
        $variable  = $instruction[1];
        $input = null;
        if(count($instruction) === 3) {
            $input = $instruction[2];
            if(!is_numeric($input)) {
                $input = $this->storage[$input] ?? 0;
            }
            $input = intval($input);
        }
        $this->$operation($variable, $input);
        $this->pc++;

        if($this->pc >= count($this->instructions)) return false;
        return true;
    }
}

$alu = new ALU();
$program = file('24.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

if(!isset($argv[1])) die(sprintf("Please provide a number to validate.\nExample: php %s 99999999999999\n", $argv[0]));
if(!is_numeric($argv[1]) || strlen($argv[1]) !== 14 || strpos($argv[1], 0)) die("Invalid number provided.\n");

$alu->load_program($program);
$alu->load_input($argv[1]);
while($alu->read_instruction());
if($alu->read_variable('z') == 0) printf("%d is a valid model number.\n", $argv[1]);
else printf("%d is an invalid model number.\n", $argv[1]);
