<?php
$in = file('13.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$dots = [];
$fold = [];
foreach($in as $line) {
    if(preg_match("/(\d+),(\d+)/", $line)) {
        list($x, $y) = explode(",", $line);
        $dots[$y][$x] = true;
    } else {
        $split = explode(" ", $line);
        $split = explode("=", $split[2]);
        $pair = [0, 0];
        if($split[0] == "x") $pair[1] = $split[1];
        else $pair[0] = $split[1];
        $fold[] = $pair;
    }
}

function fold(array $paper, array $instruction): array {
    if($instruction[0] != 0) {
        $fold_slice = array_filter($paper, function($k) use ($instruction) {
            return $k > $instruction[0];
        }, ARRAY_FILTER_USE_KEY);
        $left_slice = array_filter($paper, function($k) use ($instruction) {
            return $k < $instruction[0];
        }, ARRAY_FILTER_USE_KEY);

        $keys = array_map(fn($v) => ($instruction[0] - ($v - $instruction[0])), array_keys($fold_slice));
        $values = array_values($fold_slice);
        $new_slice = array_combine($keys, $values);
        foreach($new_slice as $y => $row) {
            if(!array_key_exists($y, $left_slice)) $left_slice[$y] = $row;
            else $left_slice[$y] = $left_slice[$y] + $new_slice[$y];
        }
    }
    else {
        $left_slice = [];
        foreach($paper as $y => $row) {
            foreach($row as $x => $val) {
                if($x < $instruction[1]) {
                    $left_slice[$y][$x] = $val;
                }
                else {
                    $left_slice[$y][$instruction[1] - ($x - $instruction[1])] = $val;
                }
            }
        }
    }

    $counter = 0;
    array_walk_recursive($left_slice, function($v, $k) use (&$counter) {
        $counter++;
    }, $counter);
    return [$left_slice, $counter];
}

foreach($fold as $k => $instruction) {
    list($dots, $count) = fold($dots, $instruction);
    if($k == 0) echo "Part 1: " . $count . PHP_EOL;
}

# Part 2
$max_row = max(array_keys($dots));
$max_column = 0;
foreach($dots as $row) {
    $maxc = max(array_keys($row));
    if($maxc > $max_column) $max_column = $maxc;
 }

echo "Part 2: " . PHP_EOL;
for($y = 0; $y <= $max_row; $y++) {
    for($x = 0; $x <= $max_column; $x++) {
        if($dots[$y][$x] ?? false) {
            echo "###";
        } else echo "...";
    }
    echo PHP_EOL;
}