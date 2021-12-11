<?php
$in = file('11.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach($in as &$line) {
    $line = str_split($line);
}
unset($line); // wtf php
// see warning https://www.php.net/manual/en/control-structures.foreach.php

function checkall(array $in) {
    foreach($in as $row) {
        foreach($row as $octo) {
            if($octo != 0) return false;
        }
    }
    return true;
}

function flash(array &$in, int $x, int $y, array &$flashed): int {
    $x_mov = [1, -1, 0, 0, 1, 1, -1, -1];
    $y_mov = [0, 0, 1, -1, 1, -1, 1, -1];
    $c = 1;
    $flashed[$x][$y] = true;
    $in[$x][$y] = 0;
    for($i = 0; $i < 7; $i++) {
        $new_x = $x + $x_mov[$i];
        $new_y = $y + $y_mov[$i];
        if(array_key_exists($new_x, $in) && array_key_exists($new_y, $in[$new_x]) && ($flashed[$new_x][$new_y] ?? false) !== true) {
            $in[$new_x][$new_y]++;
            if($in[$new_x][$new_y] > 9) $c += flash($in, $new_x, $new_y, $flashed);   
        }
    }
    return $c;
}

function solve(array $in, bool $part2 = false): int {
    $c = 0;
    $i_max = $part2 ? INF : 100;
    for($i = 0; $i < $i_max; $i++) {
        $flash = [];
        if($part2 && checkall($in)) return $i;
        for($x = 0; $x < count($in); $x++) {
            for($y = 0; $y < count($in[$x]); $y++) {
                if(($flash[$x][$y] ?? false) !== true) {
                    $in[$x][$y]++;
                    if($in[$x][$y] > 9) {
                        $c += flash($in, $x, $y, $flash);
                    }
                }
            }
        }
    }
    if(!$part2) return $c;
    else return 0;
}

echo solve($in) . PHP_EOL;
echo solve($in, true) . PHP_EOL;