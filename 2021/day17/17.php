<?php
$in = file('17.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
preg_match("/x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/i", $in[0], $targets);
$x_target = [$targets[1], $targets[2]];
$y_target = [$targets[3], $targets[4]];

function step($x, $y, $x_vel, $y_vel) {
    $x += $x_vel;
    $y += $y_vel;
    $x_vel = $x_vel - 1 > 0 ? $x_vel - 1 : 0;
    $y_vel -= 1;
    return [$x, $y, $x_vel, $y_vel];
}

function solve($x_vel, $y_vel, $x_target, $y_target) {
    [$x, $y] = [0, 0];
    [$min_x, $max_x] = $x_target;
    [$min_y, $max_y] = $y_target;
    # for part 1, record highest y point reached
    $big_y = 0;

    while(true) {
        [$x, $y, $x_vel, $y_vel] = step($x, $y, $x_vel, $y_vel);
        $big_y = $y > $big_y ? $y : $big_y;
        # if in box, return true
        if($x >= $min_x && $x <= $max_x && $y >= $min_y && $y <= $max_y) return [true, $big_y];
        # fail if our velocity is negative and we "overshot" our box
        if($y_vel < 0 && $y < $min_y) return [false, 0];
    }
}

for($x = 0; $x <= $x_target[1]; $x++) {
    # highest y velocity possible would get us exactly onto the box in 1 step
    for($y = $y_target[0]; $y <= -($y_target[0]); $y++) {
        $solve = solve($x, $y, $x_target, $y_target);
        if($solve[0]) $results[] = $solve[1];
    }
}

print("Part 1: " . max($results) . PHP_EOL);
print("Part 2: " . count($results) . PHP_EOL);