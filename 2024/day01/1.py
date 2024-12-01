from collections import defaultdict

def parse_input(input):
    return input.readlines()

def solve1(input):
    l1 = []
    l2 = []
    total = 0
    for l in input:
        n1, n2 = l.split("   ")
        l1.append(int(n1))
        l2.append(int(n2))
    l1 = sorted(l1)
    l2 = sorted(l2)
    for i in range(len(l1)):
        total += abs(l1[i] - l2[i])
    return total

def solve2(input):
    counts = defaultdict(int)
    l1 = []
    for l in input:
        n1, n2 = l.split("   ")
        l1.append(int(n1))
        counts[int(n2)] += 1
    c = 0
    for i in range(len(l1)):
        c += l1[i] * counts[l1[i]]
    return c

    


print("Part 1:", solve1(parse_input(open("1.in"))))
print("Part 2:", solve2(parse_input(open("1.in"))))