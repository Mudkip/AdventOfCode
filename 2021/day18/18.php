<?php

$in = file('18.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach($in as $line) {
    $fishes[] = parse($line);
}

function parse($string) {
    preg_match_all("/\d+|\[|\]/", $string, $matches);
    return $matches[0];
}
function add($one, $two) {
    return array_merge(["["], $one, $two, ["]"]);
}

function explodef($fish, $pos) {
    $numl = $fish[$pos];
    $numr = $fish[$pos+1];
    $right = null;
    $left = null;
    $c = $pos-1;
    while($c >= 0) {
        if(is_numeric($fish[$c])) {
            $left = $c;
            break;
        }
        $c--;
    }
    $c = $pos+2;
    while($c < count($fish)) {
        if(is_numeric($fish[$c])) {
            $right = $c;
            break;
        }
        $c++;
    }
    if($left !== null) {
        $fish[$left] += $numl;
    }
    if($right !== null) {
        $fish[$right] += $numr;
    }
    return array_merge(array_slice($fish, 0, $pos-1), ['0'], array_slice($fish, $pos+3));
}

function split($fish, $pos) {
    $numl = floor($fish[$pos] / 2);
    $numr = ceil($fish[$pos] / 2);
    return  array_merge(array_slice($fish, 0, $pos), ['[', $numl, $numr  , ']'], array_slice($fish, $pos+1));
}

function reduce($fish) {
    $d = 0;
    foreach($fish as $k => $char) {
        if($char == "[") $d++;
        else if($char == "]") $d--;
        else if($d == 5) {
            return explodef($fish, $k);
        }
    }
    foreach($fish as $k => $char) {
        if(is_numeric($char) && $char > 9) {
            return split($fish, $k);
        }
    }
    return false;
}

function magnitude($fish) {
    for($k = 0; $k < count($fish); $k++) {
        if(is_numeric($fish[$k]) && is_numeric($fish[$k + 1] ?? "x")) {
            $fish = array_merge(array_slice($fish, 0, $k-1), [($fish[$k] * 3) + ($fish[$k+1] * 2)], array_slice($fish, $k+3));
        }
    }
    return $fish;
}

function solve1($fishes) {
    while(count($fishes) > 1) {
        $fish1 = array_shift($fishes);
        $fish2 = array_shift($fishes);
        $added = add($fish1, $fish2);
        $r = reduce($added);
        while($r !== false) {
            $r = reduce($r);
            if($r !== false) $added = $r;
        }
        array_unshift($fishes, $added);
    }
    
    $magnitude = magnitude($fishes[0]);
    while(count($magnitude) > 1) {
        $magnitude = magnitude($magnitude);
    }
    return $magnitude[0];
}

function solve2($fishes) {
    $largest = 0;
    foreach($fishes as $i => $fish1) {
        foreach($fishes as $j => $fish2) {
            if($i == $j) continue;
            $added = add($fish1, $fish2);
            $r = reduce($added);
            while($r !== false) {
                $r = reduce($r);
                if($r !== false) $added = $r;
            }
            $magnitude = magnitude($added);
            while(count($magnitude) > 1) {
                $magnitude = magnitude($magnitude);
            }
            if($magnitude[0] > $largest) $largest = $magnitude[0];
        }
    }
    return $largest;
}
echo "Part 1: " . solve1($fishes) . PHP_EOL;
echo "Part 2: " . solve2($fishes) . PHP_EOL;