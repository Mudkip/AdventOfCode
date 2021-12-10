<?php
$in = file('10.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

function solve(array $in, $part2 = false) {
    $line_scores = [];
    $pts1 = 0;
    $scores = [
        ")" => [3, 1],
        "]" => [57, 2],
        "}" => [1197, 3],
        ">" => [25137, 4]
    ];

    $opp = [
        "(" => ")",
        "[" => "]",
        "{" => "}",
        "<" => ">",
    ];

    foreach($in as $k => $line) {
        $open = [];
        $chars = str_split($line);
        $skipline = false;
        foreach($chars as $char) {
            if(in_array($char, ['(', '[', '{', '<']))
                $open[] = $char;
            else {
                $s = $opp[array_pop($open)];
                if($char !== $s) {
                    $pts1 += $scores[$char][0];
                    $skipline = true;
                    break;
                }
            }
        }
        if($skipline) continue;
        $pts2 = 0;
        while($pop = array_pop($open)) {
            if($pop == null) break;
            $s = $opp[$pop];
            $pts2 *= 5;
            $pts2 += $scores[$s][1];
        }
        $line_scores[] = $pts2;
    }
    if(!$part2) return $pts1;
    else {
        sort($line_scores);
        return $line_scores[count($line_scores)/2];
    }
}

echo "Part 1: " . solve($in) . PHP_EOL;
echo "Part 2: " . solve($in, true) . PHP_EOL;