<?php

$in = file('5.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach($in as &$line) {
    preg_match("/^(\d+),(\d+) -> (\d+),(\d+)$/i", $line, $matches);
    $line = $matches;
}

function getInc(int $start, int $target): int {
    if ($start > $target) return -1;
    else if ($start < $target) return 1;
    return 0;
}

function solve(array $in, bool $diagonals): int {
    foreach ($in as $instruction) {
        [$match, $x1, $y1, $x2, $y2] = $instruction;
        if (!$diagonals && $x1 !== $x2 && $y1 !== $y2) continue;
        $x_it = getInc($x1, $x2);
        $y_it = getInc($y1, $y2);
        
        while ($x1 !== $x2 + $x_it || $y1 !== $y2 + $y_it) {
            $lines = $map[$x1][$y1] ?? 0;
            if ($lines === 0) {
                $map[$x1][$y1] = 1;
            } elseif ($lines === 1) {
                $map[$x1][$y1] = -1;
                $c = ($c ?? 0) + 1;
            }
            $x1 += $x_it;
            $y1 += $y_it;
        }
    }
    return $c;
}

echo "Part 1: " . solve($in, false) . PHP_EOL;
echo "Part 2: " . solve($in, true) . PHP_EOL;