def part1():
    inputs = open('4.in', 'r').read().splitlines()
    pairs = [(list(map(int, pair[0].split("-"))), list(map(int, pair[1].split("-")))) for pair in [input.split(",") for input in inputs]]
    engulf = [pair for pair in pairs if (pair[0][0] >= pair[1][0] and pair[0][1] <= pair[1][1]) or (pair[0][0] <= pair[1][0] and pair[0][1] >= pair[1][1])]
    return len(engulf)

def part2():
    inputs = open('4.in', 'r').read().splitlines()
    pairs = [(list(map(int, pair[0].split("-"))), list(map(int, pair[1].split("-")))) for pair in [input.split(",") for input in inputs]]
    engulf = [pair for pair in pairs if max(pair[0][0], pair[1][0]) <= min(pair[0][1], pair[1][1])]
    return len(engulf)

print(f"Part 1: {part1()}")
print(f"Part 2: {part2()}")