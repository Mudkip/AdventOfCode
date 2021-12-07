<?php
$in = file('7.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$positions = explode(",", $in[0]);

function solve1(array $input): int {
    sort($input);
    $len = count($input);
    if($len % 2 == 0) {
        $median = ($input[intdiv($len, 2) - 1] + $input[intdiv($len, 2)]) / 2;
    } else {
        $median = $input[intdiv($len, 2)];
    }
    $sum = array_reduce($input, fn($carry, $num) => $carry += abs($num - $median));
    return $sum;
}

function solve2(array $input): int {
    $avg = intdiv(array_sum($input), count($input));
    $sum = array_reduce($input, function($carry, $num) use ($avg) {
        $n = abs($num - $avg);
        return $carry += ($n * ($n+1) * 1/2);
    });
    return $sum;
}

$start = microtime(true);

echo solve1($positions) . PHP_EOL;
echo solve2($positions) . PHP_EOL;

$end = microtime(true);

echo "Done in " . $end - $start . " seconds" . PHP_EOL;
