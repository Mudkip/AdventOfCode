<?php
$in = file('14.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$template = $in[0];
$rules = [];

for($i = 1; $i < count($in); $i++) {
    $pair = explode(" -> ", $in[$i]);
    $rules[$pair[0]] = $pair[1];
}

function apply(string $template, array $rules, int $steps): int {
    $string = str_split($template);
    $letters = count_chars($template, 1);
    $pairs = [];
    $counts = [];

    for($i=0; $i < count($string) - 1; $i++) { 
        $pairs[$string[$i].$string[$i+1]] = ($pairs[$string[$i].$string[$i+1]] ?? 0) + 1;
    }

    foreach($letters as $k => $v) {
        $counts[chr($k)] = $v;
    }

    for($i = 0; $i < $steps; $i++) {
        $tmp = [];
        foreach($pairs as $pair => $count) {
            $rule = $rules[$pair];
            $split = str_split($pair);
            $new_pair  = $split[0] . $rule;
            $new_pair2 = $rule . $split[1];
            $tmp[$new_pair]  = ($tmp[$new_pair] ?? 0) + $count;
            $tmp[$new_pair2] = ($tmp[$new_pair2] ?? 0) + $count;
            $counts[$rule] = ($counts[$rule] ?? 0) + $count;    
        }
        $pairs = $tmp;
    }
    
    return max($counts) - min($counts);
}

echo "Part 1: " . apply($template, $rules, 10) . PHP_EOL;
echo "Part 2: " . apply($template, $rules, 40) . PHP_EOL;