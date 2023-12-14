
from heapq import heappop, heappush
from functools import lru_cache

def parse_input(input):
    return stringify(input.splitlines())

def rotate_grid_forward(grid):
    grid = restore(grid)
    return stringify(["".join(list(reversed(x))) for x in zip(*grid)])

def rotate_grid_backward(grid):
    grid = restore(grid)
    return stringify(["".join(x) for x in zip(*grid)][::-1])

def move_rocks(grid_str):
    grid = restore(grid_str)
    for y in range(len(grid)):
        free = []
        for x in range(len(grid[y]) -1, -1, -1):
            char = grid[y][x]
            match char:
                case "O":
                    if len(free) != 0:
                        new_pos = -heappop(free)
                        heappush(free, -x)
                        grid[y] = grid[y][:x] + "." + grid[y][x + 1:]
                        grid[y] = grid[y][:new_pos] + "O" + grid[y][new_pos + 1:]
                case ".":
                    heappush(free, -x)
                case "#":
                    # have to remove every number from heap that is greater than the current x
                    while len(free) != 0 and free[-1] < -x:
                        heappop(free)
    return stringify(grid)

def calculate_load(grid):
    grid = restore(grid)
    height = len(grid)
    total = 0
    for i, row in enumerate(grid):
        c = sum([1 for char in row if char == "O"]) * (height - i)
        total += c
    return total 

def stringify(grid):
    return "|".join(grid)

def restore(grid_str):
    return grid_str.split("|")

@lru_cache(maxsize=None)
def spin(grid_str):
    for _ in range(4):
        grid_str = move_rocks(rotate_grid_forward(grid_str))
    return grid_str

def solve(input):
    grid = parse_input(input)
    part_1 = calculate_load(rotate_grid_backward(move_rocks(rotate_grid_forward(grid))))

    seen = {}
    total_cycles = 1_000_000_000
    current_cycle, repeats_at = 0, 0
    while current_cycle < total_cycles:
        if grid in seen:
            repeats_at = current_cycle - seen[grid]
            break

        seen[grid] = current_cycle
        grid = spin(grid)
        current_cycle += 1

    if repeats_at:
        remaining = (total_cycles - current_cycle) % repeats_at
        for _ in range(remaining):
            grid = spin(grid)

    part_2 = calculate_load(grid)

    return part_1, part_2

input = open('14.in').read()
part_1, part_2 = solve(input)
print("Part 1:", part_1)
print("Part 2:", part_2)

