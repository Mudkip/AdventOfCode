<?php
$program = file('24.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$blocks = [];
$blockc = -1;
foreach($program as $inst) {
    if($inst === 'inp w') $blockc++;
    else $blocks[$blockc][] = $inst;
}

$stack = $maxn = $minn = [];
foreach($blocks as $k => $block) {
    if($block[3] === 'div z 1') {
        $add = explode(" ", $block[14])[2];
        array_push($stack, [$k, $add]);
    } else {
        [$prev, $prev_val] = array_pop($stack);
        $sub  = explode(" ", $block[4])[2];
        $diff = $prev_val + $sub;
        $maxn[$k]    = $diff > 0 ? 9 : 9 + $diff;
        $maxn[$prev] = $diff > 0 ? 9 - $diff : 9;
        $minn[$k]    = $diff > 0 ? 1 + $diff : 1;
        $minn[$prev] = $diff > 0 ? 1 : 1 - $diff;
    }
}
ksort($maxn);
ksort($minn);
echo "Part 1: " . implode("", $maxn) . PHP_EOL;
echo "Part 2: " . implodE("", $minn) . PHP_EOL;