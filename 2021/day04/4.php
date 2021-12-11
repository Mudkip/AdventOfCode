<?php

$in = file('4.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$input_calls = explode(",", $in[0]);
$input_boards = array_slice($in, 1);
const BOARD_SIZE = 5;

function parseBoards(array $input, int $board_size): array {
    $c = 0;
    $boards = [];
    foreach($input as $board_part) {
        $board_num = floor($c / $board_size);
        if(!array_key_exists($board_num, $boards)) {
            $boards[$board_num] = [];
        }
        array_push($boards[$board_num], preg_split('/\s+/', trim($board_part)));
        $c++;
    }
    return $boards;
}

function checkIfBingo(array $board, int $board_size, int $x, int $y): bool {
    // Row check
    for($r = 0; $r < $board_size; $r++) {
        if($board[$r][$y] !== "x") break;
        if($r === $board_size - 1) return true;
    }
    // Column check
    for($c = 0; $c < $board_size; $c++) {
        if($board[$x][$c] !== "x") break;
        if($c === $board_size - 1) return true;
    }
    return false;
}

function playCall(array &$board, string $call): array {
    for($r = 0; $r < count($board); $r++) {
        for($c = 0; $c < count($board); $c++) {
            if($board[$r][$c] == $call) {
                $board[$r][$c] = "x";
                return [$r, $c];
            }
        }
    }
    return [];
}

function getFirstWin(array $boards, array $calls): array {
    $boards_won = [];
    $boards_am = count($boards);
    foreach($calls as $call_num => $call) {
        foreach($boards as $board_num => &$board) {
            $play = playCall($board, $call);
            if(count($play) === 2) {
                [$x, $y] = $play;
                if(checkIfBingo($board, BOARD_SIZE, $x, $y)) {
                    return [$call_num, $board_num];
                }

            }
        }
    }
    return [];
}

function getLastWin(array $boards, array $calls): array {
    foreach($calls as $call_num => $call) {
        foreach($boards as $board_num => &$board) {
            $play = playCall($board, $call);
            if(count($play) === 2) {
                [$x, $y] = $play;
                if(checkIfBingo($board, BOARD_SIZE, $x, $y)) {
                    unset($boards[$board_num]);
                    if(count($boards) == 0) {
                        return [$call_num, $board_num];
                    }
                }    
            }
        }
    }
    return [];
}

function calculateAnswer(array $board, string $winning_call_idx, array $calls): int {
    $sum = 0;
    $uncalled = array_splice($calls, $winning_call_idx + 1);
    for($r = 0; $r < count($board); $r++) {
        for($c = 0; $c < count($board); $c++) {
            if(in_array($board[$r][$c], $uncalled)) {
                $sum += intval($board[$r][$c]);
            }
        }
    }
    return $sum * $calls[$winning_call_idx];
}


$boards = parseBoards($input_boards, BOARD_SIZE);

$partOne = getFirstWin($boards, $input_calls);
[$call_num, $board_num] = $partOne;
echo "Part one: " . calculateAnswer($boards[$board_num], $call_num, $input_calls) . PHP_EOL;

$partTwo = getLastWin($boards, $input_calls);
list($call_num, $board_num) = $partTwo;
echo "Part two: " . calculateAnswer($boards[$board_num], $call_num, $input_calls) . PHP_EOL;