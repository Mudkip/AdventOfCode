<?php

$in = file('19.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

# Relative to each scanner. 
# reports[ScannerNo] = [x, y, z]
$reports = [];

foreach($in as $line) {
    $scannermatch = preg_match("/--- scanner (\d+) ---/", $line, $match);
    if($scannermatch) {
        $scanner = $match[1];
    } else {
        $reports[$scanner][] = explode(",", $line);
    }
}

# Yes, I am bad at math...
function transform(array $point, int $i): array {
    [$x, $y, $z] = $point;
    $transform = match($i) {
        0 => [$x, $y, $z],
        1 => [$z, $x, $y],
        2 => [$y, $z, $x],
        3 => [-$x, $z, $y],
        4 => [$z, $y, -$x],
        5 => [$y, -$x, $z],
        6 => [$x, $z, -$y],
        7 => [$z, -$y, $x],
        8 => [-$y, $x, $z],
        9 => [$x, -$z, $y],
        10 => [-$z, $y, $x],
        11 => [$y, $x, -$z],
        12 => [-$x, -$y, $z],
        13 => [-$y, $z, -$x],
        14 => [$z, -$x, -$y],
        15 => [-$x, $y, -$z],
        16 => [$y, -$z, -$x],
        17 => [-$z, -$x, $y],
        18 => [$x, -$y, -$z],
        19 => [-$y, -$z, $x],
        20 => [-$z, $x, -$y],
        21 => [-$x, -$z, -$y],
        22 => [-$z, -$y, -$x],
        23 => [-$y, -$x, -$z],
    };
    return $transform;
}

function getDistances(array $points): array {
    $distances = [];
    for($i = 0; $i < count($points); $i++) {
        for($j = $i + 1; $j < count($points); $j++) {
            $d = array_map(fn ($p1, $p2) => pow($p2 - $p1, 2), $points[$i], $points[$j]);
            $d = array_sum($d);
            $distances[$d] = $i;
        }
    }
    return $distances;
}

function manhattan(array $p1, array $p2): int {
    return array_sum(array_map(fn ($p1, $p2) => abs($p1 - $p2), $p1, $p2));
}

function scan(array $base, array $reports, int $scanner1Idx, int $scanner2Idx): array {
    $scanner1 = $base[$scanner1Idx];
    $scanner2 = $reports[$scanner2Idx];
    $distances1 = getDistances($scanner1);
    $distances2 = getDistances($scanner2);
    $distanceIntersect = array_intersect_key($distances1, $distances2);
    if(count($distanceIntersect) >= 11) {
        for($i = 0; $i < 24; $i++) {
            $scanner2Transform = array_map(fn($p) => transform($p, $i), $scanner2);
            foreach($distanceIntersect as $distance => $val) {
                $pt2Translate = [];
                $scanner1_keys = [];
                $scanner1Pt1 = $scanner1[$distances1[$distance]];
                $scanner2Pt1 = $scanner2Transform[$distances2[$distance]];
                $d = array_map(fn ($p1, $p2) => $p1 - $p2, $scanner1Pt1, $scanner2Pt1);
                foreach($scanner2Transform as $pt2Transform) {
                    $add = array_map(fn ($p, $dist) => $p + $dist, $pt2Transform, $d);
                    $pt2Translate[implode("_", $add)] = $add;
                }
                foreach($scanner1 as $pt) {
                    $scanner1Set[implode("_", $pt)] = true;
                }
                if(count(array_intersect_key($pt2Translate, $scanner1Set)) >= 12) {
                    $pt2Translate = array_values($pt2Translate);
                    return [$pt2Translate, $d];
                }
            }
        }
    }
    return [false, false];
}


function solve(array $reports) {
    $checked = [];
    $locations = [[0, 0, 0]];
    $normalized = [0 => $reports[0]];

    while(count($reports) !== count($checked)) {
        for($scannerId = 0; $scannerId < count($reports); $scannerId++) {
            if(($checked[$scannerId] ?? false) || !array_key_exists($scannerId, $normalized)) continue;
            for($scannerCompare = 0; $scannerCompare < count($reports); $scannerCompare++) {
                if($scannerId == $scannerCompare || array_key_exists($scannerCompare, $normalized)) continue;
                [$translatedPoints, $relativeLocation] = scan($normalized, $reports, $scannerId, $scannerCompare);
                if($translatedPoints) {
                    $normalized[$scannerCompare] = $translatedPoints;
                    $locations[] = $relativeLocation;
                }
            }
            $checked[$scannerId] = true;
        }
    }

    $maxDistance = 0;
    for($i = 0; $i < count($locations); $i++) {
        for($j = $i+1; $j < count($locations); $j++) {
            $manhattan = manhattan($locations[$i], $locations[$j]);
            $maxDistance = $manhattan > $maxDistance ? $manhattan : $maxDistance;
        }
    }

    echo "Part 1: " . count(array_unique(array_reduce($normalized, 'array_merge', []), SORT_REGULAR)) . PHP_EOL;
    echo "Part 2: " . $maxDistance . PHP_EOL;
}

solve($reports);