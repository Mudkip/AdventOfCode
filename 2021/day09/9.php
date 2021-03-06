<?php
$in = file('9.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach($in as &$line) {
    $line = str_split($line);
}

function compare4(int $num, int $adj1, int $adj2, int $adj3, int $adj4): ?int {
    return ($num < $adj1 && $num < $adj2 && $num < $adj3 && $num < $adj4) ? $num : null;
}

function explore(array &$in, int $x, int $y): int {
    if($x < 0 || $y < 0 || $x >= count($in) || $y >= count($in[$x])) return 0;
    if($in[$x][$y] == 9) return 0;

    $in[$x][$y] = 9;

    return explore($in, $x, $y - 1) + explore($in, $x, $y + 1) + explore($in, $x + 1, $y) + explore($in, $x - 1, $y) + 1;
}

function explore_bfs(array &$in, int $x, int $y): int {
    $add_x = [1, -1, 0, 0];
    $add_y = [0, 0, 1, -1];
    $to_visit = [[$x,$y]];
    $c = 0;
    while(!empty($to_visit)) {
        [$cx, $cy] = array_shift($to_visit);
        if($cx < 0 || $cy < 0 || $cx >= count($in) || $cy >= count($in[$cx]) || $in[$cx][$cy] == 9) continue;
        $in[$cx][$cy] = 9;
        for($i = 0; $i < 4; $i++) {
            array_push($to_visit, [$cx + $add_x[$i], $cy + $add_y[$i]]);
        }
        $c++;
    }
    return $c;
}

function solve(array $in, $part2 = false): int {
    $lowest = [];
    $basins = [];
    
    for($i = 0; $i < count($in); $i++) {
        for($j = 0; $j < count($in[$i]); $j++) {
            $compare = compare4($in[$i][$j], $in[$i][$j-1] ?? 9, $in[$i][$j+1] ?? 9, $in[$i-1][$j] ?? 9, $in[$i+1][$j] ?? 9);
            if($compare !== null) {
                $basins[] = explore($in, $i, $j);
                $lowest[] = $compare;
            }
        }
    }

    if($part2) {
        rsort($basins);
        return array_product(array_slice($basins, 0, 3));
    }

    else return array_sum($lowest) + count($lowest);
}

echo "Part 1: " . solve($in) . PHP_EOL;
echo "Part 2: " . solve($in, true) . PHP_EOL;