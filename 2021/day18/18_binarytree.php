<?php
class Node {
    private string $val;
    private ?Node $left = null;
    private ?Node $right = null;
    
    function __construct(string $value) { $this->val = $value;}
    function val(): string { return $this->val; }
    function left(): ?Node { return $this->left; }
    function right(): ?Node { return $this->right; }
    function setVal(string $val) { $this->val = $val; }
    function setLeft(?Node $node): void { $this->left = $node; }
    function setRight(?Node $node): void { $this->right = $node; }
}

function parse(string $line) {
    $splitPos = 0;
    $openBr = 0;
    $split = str_split($line);
    foreach($split as $k => $char) {
        $inc = false;
        if($char == "[") {
            $inc = true;
            $openBr++;
        }
        if($char == "]") $openBr--;
        if(!$inc && $openBr === 1) {
            $splitPos = $k;
            break;
        }
    }

    return [substr($line, 1, $splitPos), substr($line, $splitPos+2, -1)];
}

function add(string|Node $one, string|Node $two): Node {
    $one = is_string($one) ? breakdown($one) : $one;
    $two = is_string($two) ? breakdown($two) : $two;
    $root = new Node("=");
    $root->setLeft($one);
    $root->setRight($two);
    while(reduce($root));
    return $root;
}

function breakdown(string $line): Node {
    $root = new Node("=");
    [$left, $right] = parse($line);
    if(is_numeric($left)) {
        $lNode = new Node($left);
    } else {
        $lNode = breakdown($left);
    }
    if(is_numeric($right)) {
        $rNode = new Node($right);
    } else {
        $rNode = breakdown($right);
    }
    $root->setLeft($lNode);
    $root->setRight($rNode);
    return $root;
}

function expl(?Node $root, int $depth = 0, ?Node &$prevNode = null) {
    if($root === null) return false;

    if($depth >= 4 && $root->left() && $root->right()) {
        return [$root, $prevNode];
    } elseif(is_numeric($root->val())) {
        $prevNode = $root;
    }

    $left = expl($root->left(), $depth + 1, $prevNode);
    if(is_array($left)) return $left;
    
    $right = expl($root->right(), $depth + 1, $prevNode);
    if(is_array($right)) return $right;

    return false;
}

function findNextNumberNode(?Node $root, Node $explodeNode, bool &$foundExplodeNode = false) {
    if($root === null) return false;

    $left = findNextNumberNode($root->left(), $explodeNode, $foundExplodeNode);
    if($left) return $left;

    if($foundExplodeNode && is_numeric($root->val())) {
        return $root;
    } elseif($root === $explodeNode) {
        $foundExplodeNode = true;
        return false;
    }

    $right = findNextNumberNode($root->right(), $explodeNode, $foundExplodeNode);
    if($right) return $right;
}

function split(?Node $root) {
    if($root === null) return false;
    $left = split($root->left());
    if($left) return $left;
    
    if(is_numeric($root->val()) && $root->val() > 9) {
        $root->setLeft(new Node(floor($root->val() / 2)));
        $root->setRight(new Node(ceil($root->val() / 2)));
        $root->setVal("=");
        return true;
    }
    $right = split($root->right());
    if($right) return $right;

    return false;
}

function reduce(Node $root) {
    $explode = expl($root);
    if($explode !== false) {
        [$explodeNode, $leftNode] = $explode;
        $rightNode = findNextNumberNode($root, $explodeNode);
        if($leftNode !== null) {
            $leftNode->setVal($leftNode->val() + $explodeNode->left()->val());
        }
        if($rightNode !== null) {
            $rightNode->setVal($rightNode->val() + $explodeNode->right()->val());
        }
        $explodeNode->setLeft(null);
        $explodeNode->setRight(null);
        $explodeNode->setVal("0");
        return true;
    }

    if(split($root)) return true;
    
    return false;
}

function magnitude(Node $root) {
    if($root === null) return 0;
    if(is_numeric($root->val())) return $root->val();
    else return (3 * magnitude($root->left())) + (2 * magnitude($root->right()));
}

function solve(array $homework) {
    while(count($homework) > 1) {
        $l1 = array_shift($homework);
        $l2 = array_shift($homework);
        $nl = add($l1, $l2);
        array_unshift($homework, $nl);
    }
    return magnitude($homework[0]);
}

function solve2(array $homework) {
    $max = 0;
    foreach($homework as $i => $one) {
        foreach($homework as $j => $two) {
            if($i === $j) continue;
            $magnitude = magnitude(add($one, $two));
            if($magnitude > $max) $max = $magnitude;
        }
    }
    return $max;
}

$in = file('18.in', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
echo "Part 1: " . solve($in) . PHP_EOL;
echo "Part 2: " . solve2($in) . PHP_EOL;