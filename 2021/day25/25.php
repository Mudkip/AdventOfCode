<?php
$in = file('25.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

$map = [];
foreach($in as $x => $line) {
    $map[$x] = str_split($line);
}

function emptyForward($map, $x, $y): bool {
    [$adjx, $adjy] = forwardCoords($map, $x, $y);
    if($map[$adjx][$adjy] == ".") return true;
    return false;
}

function forwardCoords($map, $x, $y): array {
    $xforward = $map[$x][$y] == ">" ? 0 : 1;
    $yforward = $map[$x][$y] == ">" ? 1 : 0;
    $adjx = ($x + $xforward) % count($map);
    $adjy = ($y + $yforward) % count($map[$x]);
    return [$adjx, $adjy];
}

function move($map, $east) {
    $moved = 0;
    $new_map = $map;
    foreach($map as $x => $row) {
        foreach($row as $y => $val) {
            $emptyForward = emptyForward($map, $x, $y);
            if($emptyForward) {
                [$fx, $fy] = forwardCoords($map, $x, $y);
                if($east && $val == ">") {
                    $new_map[$x][$y] = ".";
                    $new_map[$fx][$fy] = ">";
                    $moved++;
                } elseif(!$east && $val == "v") {
                    $new_map[$x][$y] = ".";
                    $new_map[$fx][$fy] = "v";
                    $moved++;
                }    
            }
        }
    }
    return [$new_map, $moved];
}

$moved = INF;
$step = 0;
while($moved !== 0) {
    [$map, $moved_e] = move($map, true);
    [$map, $moved_s] = move($map, false);
    $moved = $moved_e + $moved_s;
    $step++;
}

echo "Part 1: " . $step . PHP_EOL;