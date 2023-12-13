

def parse_input(input):
    return [grid.splitlines() for grid in input.split("\n\n")]

def transpose(grid):
    return list(map(list, zip(*grid)))

def find_reflection(grid, possible_mismatches):
    for reflection in range(1, len(grid[0])):
        total_mismatches = 0
        for row in grid:
            before, after = reversed(row[:reflection]), row[reflection:]
            total_mismatches += sum([1 for x, y in zip(before, after) if x != y])
        if total_mismatches == possible_mismatches:
            return reflection

def solve(input, possible_mismatches):
    grids = parse_input(input)
    total = 0
    for grid in grids:
        total += find_reflection(grid, possible_mismatches) or 0
        total += (find_reflection(transpose(grid), possible_mismatches) or 0) * 100
    return total       
 
input = open('13.in').read()
part_1 = solve(input, 0)
part_2 = solve(input, 1)
print("Part 1:", part_1)
print("Part 2:", part_2)

