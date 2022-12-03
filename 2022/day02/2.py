same = {
    'A': 'X',
    'B': 'Y',
    'C': 'Z'
}
scores = {
    'X': 1,
    'Y': 2,
    'Z': 3,
}
win = {
    'A': 'Y',
    'B': 'Z',
    'C': 'X'
}
lose = {
    'A': 'Z',
    'B': 'X',
    'C': 'Y'
}
draw = {
    'A': 'X',
    'B': 'Y',
    'C': 'Z'
}

def part1():
    input = open("2.in", "r")
    score = 0
    for line in input.readlines():
        line = line.strip()
        other, you = line.split(' ')
        score += scores[you]
        if win[other] == you:
            score += 6
        elif same[other] == you:
            score += 3
    return score

def part2():
    input = open("2.in", "r")
    score = 0
    for line in input.readlines():
        line = line.strip()
        other, you = line.split(' ')
        if you == 'X':
            play = lose[other]
        elif you == 'Y':
            play = draw[other]
            score += 3
        else:
            play = win[other]
            score += 6
        score += scores[play]
    return score
        

print(f"Part 1: {part1()}")
print(f"Part 2: {part2()}")
