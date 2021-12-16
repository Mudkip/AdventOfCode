<?php

class PQLol extends SplPriorityQueue
{
    public function compare($priority1, $priority2)
    {
        if ($priority1 === $priority2) return 0;
        return $priority1 > $priority2 ? -1 : 1;
    }
}


$in = file('15.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
foreach($in as $k => $line) {
    $splt = str_split($line);
    foreach($splt as $char) {
        $grid[$k][] = intval($char);  
    }
}

foreach($in as $k => $line) {
    $splt = str_split($line);
    $c = count($splt);
    foreach($splt as $l => $char) {
        $grid2[$k][$l] = intval($char);
    }
    $map = $grid2[$k];
    for($i = 1; $i < 5; $i++) {
        $map = array_map(fn($x) => $x + 1 != 10 ? $x + 1 : 1, $map);
        $grid2[$k] = array_merge($grid2[$k], $map);
    }        
}


foreach($grid2 as $k => $row) {
    $map = array_map(fn($x) => $x + 1 != 10 ? $x + 1 : 1, $row);
    $grid2[] = $map;
    $row_log[$k] = $map;
}

for($i = 0; $i < 3; $i++) {
    foreach($row_log as $k => $row) {
        $map = array_map(fn($x) => $x + 1 != 10 ? $x + 1 : 1, $row);
        $grid2[] = $map;
        $row_log[$k] = $map;
    }
}


function explore(array $input, int $x, int $y): int {
    $mod_x = [0, 0, 1, -1];
    $mod_y = [-1, 1, 0, 0];
    foreach($input as $x1 => $col) {
        foreach($input as $y1 => $val) {
            $scores[$x1][$y1] = INF;
        }
    }
    $scores[$x][$y] = 0;
    $queue = new PQLol();
    $queue->setExtractFlags(PQLol::EXTR_BOTH); 
    $queue->insert([$x, $y], 0);
    while(!$queue->isempty()) {
        $extract = $queue->extract();
        $distance = $extract['priority'];
        list($node_x, $node_y) = $extract['data'];
        $visited[$node_x][$node_y] = true;
        for($i = 0; $i < 4; $i++) {
            $neighbor_x = $node_x + $mod_x[$i];
            $neighbor_y = $node_y + $mod_y[$i];
            $neighbor_distance = $input[$neighbor_x][$neighbor_y] ?? -1;
            if($neighbor_distance !== -1 && !($visited[$neighbor_x][$neighbor_y] ?? false)) {
                $old_cost = $scores[$neighbor_x][$neighbor_y];
                $new_cost = $scores[$node_x][$node_y] + $neighbor_distance;
                if($new_cost < $old_cost) {
                    $queue->insert([$neighbor_x, $neighbor_y], intval($new_cost));
                    $scores[$neighbor_x][$neighbor_y] = $new_cost;
                }

            }
        }
    }
    $lr = end($scores);
    return end($lr);
}

echo "Part 1: " .explore($grid, 0, 0) . PHP_EOL;
echo "Part 2: " . explore($grid2, 0, 0) . PHP_EOL;