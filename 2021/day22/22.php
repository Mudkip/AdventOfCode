<?php
$in = file('22.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

function volume(int $x1, int $x2, int $y1, int $y2, int $z1, int $z2): int {
    return ($x2 - $x1 + 1) * ($y2 - $y1 + 1) * ($z2 - $z1 + 1);
}

function getKey(int $x1, int $x2, int $y1, int $y2, int $z1, int $z2): string {
    return sprintf("%d_%d_%d_%d_%d_%d", $x1, $x2, $y1, $y2, $z1, $z2);
}

function getCoordinates(string $key): array {
    return explode("_", $key);
}

function solve(array $in, int $maxnum = PHP_INT_MAX): int {
    $zones = [];
    foreach($in as $line) {
        # Parse input
        preg_match("/(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/i", $line, $targets);
        [$state, $x1, $x2, $y1, $y2, $z1, $z2] = array_slice($targets, 1);

        # For part 1
        if(abs($x1) > $maxnum || abs($x2) > $maxnum || abs($y1) > $maxnum || abs($y2) > $maxnum || abs($z1) > $maxnum || abs($z2) > $maxnum) {
            continue;
        }

        foreach($zones as $zonekey => $value) {
            [$x1z, $x2z, $y1z, $y2z, $z1z, $z2z] = getCoordinates($zonekey);
            # See https://i.imgur.com/im0ql9D.png to understand what's going on below
            $x1i = $x1 > $x1z ? $x1 : $x1z;
            $x2i = $x2 < $x2z ? $x2 : $x2z;
            $y1i = $y1 > $y1z ? $y1 : $y1z;
            $y2i = $y2 < $y2z ? $y2 : $y2z;
            $z1i = $z1 > $z1z ? $z1 : $z1z;
            $z2i = $z2 < $z2z ? $z2 : $z2z;
            
            # Make sure the cubes actually intersect.
            # If they don't the first coordinate will be bigger than the second
            # due to the above min and max calculations
            if($x1i > $x2i || $y1i >$y2i || $z1i > $z2i) continue;

            $key = getKey($x1i, $x2i, $y1i, $y2i, $z1i, $z2i);
            $zones[$key] = ($zones[$key] ?? 0) - $value;
        }

        if($state === "on") $zones[getKey($x1, $x2, $y1, $y2, $z1, $z2)] = 1;
        
        
    }


    return array_sum(array_map(fn($v, $k) => volume(...getCoordinates($k))*$v, $zones, array_keys($zones)));
}

echo "Part 1: ". solve($in, 50) . PHP_EOL;
echo "Part 2: ". solve($in) . PHP_EOL;