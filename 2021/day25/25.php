<?php
$in = file('25.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

$map = [];
foreach($in as $x => $line) {
    $map[$x] = str_split($line);
}

function emptyForward(array $map, int $x, int $y): bool {
    [$adjx, $adjy] = forwardCoords($map, $x, $y);
    if($map[$adjx][$adjy] === ".") return true;
    return false;
}

function forwardCoords(array $map, int $x, int $y): array {
    $xforward = $map[$x][$y] === ">" ? 0 : 1;
    $yforward = $map[$x][$y] === ">" ? 1 : 0;
    $adjx = ($x + $xforward) % count($map);
    $adjy = ($y + $yforward) % count($map[$x]);
    return [$adjx, $adjy];
}

function move(array $map, bool $east): array {
    $moved = false;
    $new_map = $map;
    foreach($map as $x => $row) {
        foreach($row as $y => $val) {
            if($val === ".") continue;
            if(!emptyForward($map, $x, $y) || (($east && $val !== ">") || (!$east && $val !== "v"))) continue;
            [$fx, $fy] = forwardCoords($map, $x, $y);
            $new_map[$x][$y] = ".";
            $new_map[$fx][$fy] = $val;
            $moved = true;
        }
    }
    return [$new_map, $moved];
}

$moved = true;
$step = 0;
while($moved) {
    [$map, $moved_e] = move($map, true);
    [$map, $moved_s] = move($map, false);
    $moved = $moved_e + $moved_s;
    $step++;
}

echo "Part 1: " . $step . PHP_EOL;