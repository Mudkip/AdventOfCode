<?php

$in = file('20.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$algorithm = str_split($in[0]);
$image     = array_map(fn($l) => str_split($l), array_slice($in, 1));


function visualize(array $image) {
    foreach($image as $row) {
        echo implode("", $row) . PHP_EOL;
    }
}
function deconvolute(array $image, int $x, int $y): string {
    $line = "";
    for($i = $x-1; $i <= $x+1; $i++) {
        for($j = $y-1; $j <= $y+1; $j++) {
            $line .= $image[$i][$j];
        }
    }
    return $line;
}

function addBorder(array $image, int $n, int $i): array {
    $c = $i % 2 == 0 ? "." : "#";
    for($i = 0; $i < $n; $i++) {
        array_unshift($image, array_fill(0, count($image[0]), $c));
        array_push($image, array_fill(0, count($image[0]), $c));
    }
    for($r = 0; $r < count($image); $r++) {
        for($i = 0; $i < $n; $i++) {
            array_unshift($image[$r], $c);
            array_push($image[$r], $c);
        }
    }
    return $image;
}

function removeBorder(array $image, int $n): array {
    for($i = 0; $i < $n; $i++) {
        array_shift($image);
        array_pop($image);
    }
    for($r = 0; $r < count($image); $r++) {
        for($i = 0; $i < $n; $i++) {
            array_shift($image[$r]);
            array_pop($image[$r]);
        }
    }
    return $image;
}

function toBinary(string $line): string {
    $line = str_split($line);
    $line = array_map(fn($v) => $v === "." ? "0" : "1", $line);
    return implode("", $line);
}

function lookupAlgorithm(array $image, array $algorithm, int $x, int $y): string {
    $binary = toBinary(deconvolute($image, $x, $y));
    $algPos = bindec($binary);
    return $algorithm[$algPos];
}

function updateImage(array $image, array $algorithm): array {
    $updatedImage = $image;
    for($x = 1; $x < count($updatedImage) - 1; $x++) {
        for($y = 1; $y < count($updatedImage[0]) - 1; $y++) {
            $updatedImage[$x][$y] = lookupAlgorithm($image, $algorithm, $x, $y);
        }
    }
    return $updatedImage;
}

function iterUpdateImage(array $image, array $algorithm, int $iterations): array {
    for($i = 0; $i < $iterations; $i++) {
        $image = addBorder($image, 3, $i);
        $image = updateImage($image, $algorithm);
        $image = removeBorder($image, 2);
    }
    return $image;
}

function countLight(array $image): int {
    $flat = array_merge(...$image);
    return array_count_values($flat)['#'];
}

function solve(array $image, array $algorithm, bool $part2 = false): int {
    $image = iterUpdateImage($image, $algorithm, $part2 ? 50 : 2);
    return countLight($image);
}

echo "Part 1: " . solve($image, $algorithm, false) . PHP_EOL;
echo "Part 2: " . solve($image, $algorithm, true) . PHP_EOL;