<?php
$in = file('6.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$fish = explode(",", $in[0]);

const REPRODUCTION_DELAY = 6;
const READY_DELAY = 2;

function expand(array $input, int $days): int {
    $map = [];
    foreach($input as $ind) {
        $map[$ind] = ($map[$ind] ?? 0) + 1;
    }
    
    for($i = 0; $i < $days; $i++) {
        $map2 = [];
        foreach($map as $key => $val) {
            $new_key = $key-1;
            if($new_key == -1) {
                $new_key = 6;
                $map2[8] = $val;
            }
            $map2[$new_key] = ($map2[$new_key] ?? 0) + $val;
        }
        $map = $map2;
    }
    return array_sum($map);
}


echo "Part 1: " . expand($fish, 80) . PHP_EOL;
echo "Part 2: " . expand($fish, 256) . PHP_EOL;