<?php

$in = file('1.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

function solve(array $input, int $window): int {
    $c = 0;
    for($i = 0; $i < count($input); ++$i) {
        if($i + $window > count($input)) break;
        if(array_sum(array_slice($input, $i + 1, $window)) > array_sum(array_slice($input, $i, $window)))
            ++$c;
    }
    return $c;
}

echo "Part 1: " . solve($in, 1) . PHP_EOL;
echo "Part 2: " . solve($in, 3) . PHP_EOL;