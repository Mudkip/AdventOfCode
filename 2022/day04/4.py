def parse_inputs():
    inputs = open('4.in', 'r').read().splitlines()
    return [(list(map(int, pair[0].split("-"))), list(map(int, pair[1].split("-")))) for pair in [input.split(",") for input in inputs]]

def solve(pairs, condition):
    return len([pair for pair in pairs if condition(pair)])

pairs = parse_inputs()
print(f"Part 1: {solve(pairs, lambda pair: (pair[0][0] >= pair[1][0] and pair[0][1] <= pair[1][1]) or (pair[0][0] <= pair[1][0] and pair[0][1] >= pair[1][1]))}")
print(f"Part 2: {solve(pairs, lambda pair: max(pair[0][0], pair[1][0]) <= min(pair[0][1], pair[1][1]))}")