<?php

$in = file('21.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$pos = [substr($in[0], -1), substr($in[1], -1)];

function roll(int $die = 0): int {
    return ($die % 100) + 1;
}

function rollSumN(int $die, int $n): array {
    $sum = 0;
    for($i = 0; $i < $n; $i++) {
        $die = roll($die);
        $sum += $die;
    }
    return [$die, $sum];
}

function nextPos(int $curPos, int $roll): int {
    return (($curPos + $roll - 1) % 10) + 1;
}

function calculateWins(int $pl1S, int $pl2S, int $pl1P, int $pl2P, array &$cache = []) {
    if($pl1S >= 21) return [1, 0];
    if($pl2S >= 21) return [0, 1];
    $cacheKey = implode("_", [$pl1S, $pl2S, $pl1P, $pl2P]);
    if(array_key_exists($cacheKey, $cache)) return $cache[$cacheKey];

    foreach(range(1, 3) as $roll1) {
        foreach(range(1, 3) as $roll2) {
            foreach(range(1,3) as $roll3) {
                $pl1P_n = (($pl1P + $roll1 + $roll2 + $roll3 - 1) % 10) + 1;
                $pl1S_n = $pl1S + $pl1P_n;
                $pl2Turn = calculateWins($pl2S, $pl1S_n, $pl2P, $pl1P_n, $cache);
                $wins[0] = ($wins[0] ?? 0) + $pl2Turn[1];
                $wins[1] = ($wins[1] ?? 0) + $pl2Turn[0];
            }
        }
    }
    $cache[$cacheKey] = $wins;
    return $wins;
}

function solve1(array $pos): int {
    $pl1Turn = true;
    $scores = [0, 0];
    $die = 0;
    $rollCount = 0;
    $rollAmnt = 3;
    while($scores[0] < 1000 && $scores[1] < 1000) {
        $pl = $pl1Turn ? 0 : 1;
        [$die, $rolled] = rollSumN($die, $rollAmnt);
        $newPos = nextPos($pos[$pl], $rolled);
        $scores[$pl] += $newPos;
        $pos[$pl] = $newPos;
        $rollCount += $rollAmnt;
        $pl1Turn = !$pl1Turn;
    }
    return min($scores) * $rollCount;
}

function solve2(array $pos): int {
    return max(calculateWins(0, 0, $pos[0], $pos[1]));
}


echo "Part 1: " . solve1($pos) . PHP_EOL;
echo "Part 2: " . solve2($pos) . PHP_EOL;