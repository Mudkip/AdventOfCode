def solve(n):
    input = open("6.in", "r").read().strip()
    return next(i+n for i in range(len(input)) if len(set(input[i:i+n])) == n)
print(f"Part 1: {solve(4)}")
print(f"Part 2: {solve(14)}")