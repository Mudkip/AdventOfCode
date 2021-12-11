<?php

$in = file('3.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

function getMostCommonBit(array $list, int $position, int $tiebreak): int {
    $count = 0;
    foreach($list as $binary) {
        switch(str_split($binary)[$position]) {
            case '1':
                $count++;
                break;
            case '0':
                $count--;
                break;
        }
    }
    if($count > 0) return 1; # 1 more common 
    if($count < 0) return 0; # 0 more common
    else return $tiebreak; # equal
}

function getLeastCommonBit(array $list, int $position, int $tiebreak): int {
    $mostCommonBit = getMostCommonBit($list, $position, -1);
    if($mostCommonBit === -1) return $tiebreak;
    else {
        return $mostCommonBit === 1 ? 0 : 1;
    }
}

function solve1(array $input): int {
    $mostCommon = "";
    $leastCommon = "";
    for($i = 0; $i < strlen($input[0]); $i++) {
        $mostCommon .= strval(getMostCommonBit($input, $i, -1));
        $leastCommon .= strval(getMostCommonBit($input, $i, -1)) === '1' ? '0' : '1';
    }
    return bindec($mostCommon) * bindec($leastCommon);
}

function solve2(array $input): int {
    $mostCommonArr = $input;
    $i = 0;
    while(count($mostCommonArr) > 1) {
        $mostCommonBit = strval(getMostCommonBit($mostCommonArr, $i, 1));
        foreach($mostCommonArr as $key => $binary) {
            if(str_split($binary)[$i] !== $mostCommonBit) {
                unset($mostCommonArr[$key]);
            }
        }
        $i++;
    }
    $leastCommonArr = $input;
    $i = 0;
    while(count($leastCommonArr) > 1) {
        $leastCommonBit = strval(getLeastCommonBit($leastCommonArr, $i, 0));
        foreach($leastCommonArr as $key => $binary) {
            if(str_split($binary)[$i] !== $leastCommonBit) {
                unset($leastCommonArr[$key]);
            }
        }
        $i++;
    }
    return bindec(current($mostCommonArr)) * bindec(current($leastCommonArr));
}

echo "Part 1: " . solve1($in) . PHP_EOL;
echo "Part 2: " . solve2($in) . PHP_EOL;