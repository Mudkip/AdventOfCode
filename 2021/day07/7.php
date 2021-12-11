<?php
$in = file('7.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$positions = explode(",", $in[0]);

function solve1(array $input): int {
    $lowestSum = INF;
    foreach($input as $pos) {
        $sum = 0;
        foreach($input as $pos2) {
            $sum += abs($pos - $pos2);
        }
        if($sum < $lowestSum) {
            $lowestSum = $sum;
        }
    }
    return $lowestSum;
}

function solve2(array $input): int {
    $lowestSum = INF;
    $min = min($input);
    $max = max($input);
    for($i = $min; $i <= $max; $i++) {
        $sum = 0;
        foreach($input as $pos) {
            $n = abs($pos - $i);
            $sum += ($n * ($n+1) * 1/2);
        }
        if($sum < $lowestSum) {
            $lowestSum = $sum;
        }
    }
    return $lowestSum;
}

$start = microtime(true);

echo solve1($positions) . PHP_EOL;
echo solve2($positions) . PHP_EOL;

$end = microtime(true);

echo "Done in " . $end - $start . " seconds" . PHP_EOL;