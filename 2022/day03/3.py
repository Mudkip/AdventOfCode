def part1():
    input = open("3.in", "r").read().splitlines()
    rucksacks = ((set(list(x[:len(x)//2])), set(list(x[len(x)//2:]))) for x in input)
    prios = (ord((rucksack[0] & rucksack[1]).pop())-96 for rucksack in rucksacks)
    normalize = (prio if prio > 0 else prio+58 for prio in prios)
    return sum(normalize)

def part2():
    input = open("3.in", "r").read().splitlines()
    groups = [input[i:i+3] for i in range(0,len(input), 3)]
    badges = [(set(group[0]) & set(group[1]) & set(group[2])) for group in groups]
    prios = (ord(badge.pop())-96 for badge in badges)
    normalize = (prio if prio > 0 else prio+58 for prio in prios)
    return sum(normalize)

print(f"Part 1: {part1()}")
print(f"Part 2: {part2()}")