<?php
$in = file('12.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

$pairs = [];
$actions = [];
foreach($in as $line) {
    $split = explode("-", $line);
    $actions[$split[0]][] = $split[1];
    $actions[$split[1]][] = $split[0];
}


function explore(array $actions, $part2 = false, string $cur_pos = 'start', array $visited = ['start']): int {
    if($cur_pos == 'end') return 1;
    $c = 0;
    foreach($actions[$cur_pos] as $action) {
        if(!in_array($action, $visited)) {
            $c += explore($actions, $part2, $action, array_merge($visited, (ctype_lower($action) ? [$action] : [])));
        }
        elseif($part2 && $action != 'start') {
            $c += explore($actions, false, $action, $visited);
        }
    }
    return $c;
}

echo "Part 1: " . explore($actions) . PHP_EOL;
echo "Part 2: " . explore($actions, true) . PHP_EOL;