<?php
$in = file('8.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach($in as &$line) {
    $line = explode("|", $line);
    $line = [
        explode(" ", trim($line[0])),
        explode(" ", trim($line[1])),
    ];
}

function common_count(string $w1, string $w2): int {
    [$w1, $w2] = [str_split($w1), str_split($w2)];
    return count(array_intersect($w1, $w2));
}

function sort_word(string $word) {
    $split = str_split($word);
    sort($split);
    return implode("", $split);
}

function solve1(array $input): int {
    $sum = 0;
    foreach($input as $piece) {
        $results = $piece[1];
        $sum += array_reduce($results, fn($c, $w) => $c += in_array(strlen($w), [2,4,3,7]) ? 1 : 0);
    }
    return $sum;
}


function solve2(array $input): int {
    $sum = 0;
    foreach($input as $piece) {
        $map     = [];
        $words   = $piece[0];
        $results = $piece[1];
    
        $map[1] = current(array_filter($words, fn($x) => strlen($x) === 2));
        $map[7] = current(array_filter($words, fn($x) => strlen($x) === 3));
        $map[4] = current(array_filter($words, fn($x) => strlen($x) === 4));
        $map[8] = current(array_filter($words, fn($x) => strlen($x) === 7));
        $map[6] = current(array_filter($words, fn($x) => strlen($x) === 6 && common_count($x, $map[1]) === 1));
        $map[5] = current(array_filter($words, fn($x) => strlen($x) === 5 && common_count($x, $map[6]) === 5));
        $map[9] = current(array_filter($words, fn($x) => strlen($x) === 6 && common_count($x, $map[4]) === 4));
        $map[0] = current(array_filter($words, fn($x) => strlen($x) === 6 && !in_array($x, $map)));
        $map[3] = current(array_filter($words, fn($x) => strlen($x) === 5 && common_count($x, $map[1]) === 2));
        $map[2] = current(array_filter($words, fn($x) => !in_array($x, $map)));
    
        $map = array_map(fn($w) => sort_word($w), $map);
        $inverse_map = array_flip($map);
        $results = array_map(fn($w) => sort_word($w), $results);
        $results = array_map(fn($w) => $inverse_map[$w], $results);
        $number  = implode("", $results);
        $sum += $number;
    }
    return $sum;
}

echo "Part 1: " . solve1($in) . PHP_EOL;
echo "Part 2: " . solve2($in) . PHP_EOL;