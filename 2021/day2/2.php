<?php

$in = file('2.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
for($i = 0; $i < count($in); $i++) {
    $in[$i] = explode(" ", $in[$i]);
}

function solve(array $input): int {
    $horizontal = 0;
    $depth = 0;
    foreach($input as $instruction) {
        if($instruction[0] === "up") $depth -= intval($instruction[1]);
        if($instruction[0] === "down") $depth += intval($instruction[1]);
        if($instruction[0] === "forward") $horizontal += intval($instruction[1]);
    }
    return $depth * $horizontal;
}

function solve2(array $input): int {
    $horizontal = 0;
    $depth = 0;
    $aim = 0;
    foreach($input as $instruction) {
        if($instruction[0] === "up") $aim -= intval($instruction[1]);
        if($instruction[0] === "down") $aim += intval($instruction[1]);
        if($instruction[0] === "forward") {
            $horizontal += intval($instruction[1]);
            $depth += $aim * intval($instruction[1]);
        }

    }
    return $depth * $horizontal;
}

echo "Part 1: " . solve($in) . PHP_EOL;
echo "Part 2: " . solve2($in) . PHP_EOL;