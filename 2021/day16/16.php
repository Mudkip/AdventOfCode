<?php
$in = file('16.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$hex = $in[0];
$binary = hextobin($hex);

function hextobin(string $hex): string {
    $result = '';
    for ($i = 0; $i < strlen($hex); $i++){
        $conv = base_convert($hex[$i], 16, 2);
        $result .= str_pad($conv, 4, '0', STR_PAD_LEFT);
    }
    return $result;
}

function parseLiteral(int $v, string $bin): array {
    $str = '';
    $last = false;
    $poffset = 6;
    $plen = 5;
    while(!$last) {
        $grp = substr($bin, $poffset, $plen);
        $last = substr($grp, 0, 1) == 0;
        $val = substr($grp, 1);
        $poffset += $plen;
        $str .= $val;
    }

    return [
        "t"     => 4,
        "v"     => $v,
        "value" => bindec($str),
        "len"   => $poffset
    ];
}

function parseOperator(int $v, int $t, string $bin): array {
    $i = substr($bin, 6, 1);
    if($i == 0) {
        $plen = bindec(substr($bin, 7, 15));
        $offset = 22;
        $offset_sub = 22;
        $subinst = substr($bin, $offset, $plen);
        $results = [];
        while($offset_sub - $offset < $plen) {
            $p = parseBin($subinst);
            $offset_sub += $p['len'];
            $subinst = substr($bin, $offset_sub, $plen);
            $results[] = $p;
        }
    }
    else {
        $pamount = bindec(substr($bin, 7, 11));
        $offset_sub = 18;
        $subinst = substr($bin, $offset_sub);
        for($i = 0; $i < $pamount; $i++) {
            $p = parseBin($subinst);
            $offset_sub += $p['len'];
            $subinst = substr($bin, $offset_sub);
            $results[] = $p;
        }
    }

    $values = array_column($results, 'value');
    $vsum = $v + array_sum(array_column($results, 'v'));
    $result = match($t) {
        0 => array_sum($values),
        1 => array_product($values),
        2 => min($values),
        3 => max($values),
        5 => $values[0] > $values[1] ? 1 : 0,
        6 => $values[0] < $values[1] ? 1 : 0,
        7 => $values[0] == $values[1] ? 1 : 0
    };

    return [
        "t"   => $t,
        "v"   => $vsum,
        "len" => $offset_sub,
        "value" => $result
    ];
}

function parseBin(string $bin): array {
    $v = bindec(substr($bin, 0, 3));
    $t = bindec(substr($bin, 3, 3));
    $literal = $t == 4;
    if($literal) {
        return parseLiteral($v, $bin);
    } else {
        return parseOperator($v, $t, $bin);
    }
}

$parse = parseBin($binary);

echo "Part 1: " .  $parse['v'] . PHP_EOL;
echo "Part 2: " .  $parse['value'] . PHP_EOL;
