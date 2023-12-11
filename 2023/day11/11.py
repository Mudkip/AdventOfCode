from itertools import combinations

def transform_input(input):
    grid = input.splitlines()
    empty_rows = ([w for w,x in enumerate(grid) if x == '.' * len(x)])
    empty_columns = ([w for w,x in enumerate(rotate_grid_forward(grid)) if x == '.' * len(x)])
    galaxies = locate_galaxies(grid)
    return galaxies, empty_rows, empty_columns

def rotate_grid_forward(grid):
    return ["".join(list(reversed(x))) for x in zip(*grid)]

def locate_galaxies(grid):
    galaxies = []
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] == "#":
                galaxies.append((y, x))
    return galaxies

def calculate_galaxy_coords(galaxies, empty_rows, empty_columns, empty_multiplier):
    new_galaxies = []
    for y, x in galaxies:
        add_y = sum([1 for row in empty_rows if row < y])
        add_x = sum([1 for column in empty_columns if column < x])
        new_galaxies.append((y + add_y * (empty_multiplier-1), x + add_x * (empty_multiplier-1)))
    return new_galaxies

def find_shortest_distance(start_galaxy, end_galaxy):
    y_diff = abs(start_galaxy[0] - end_galaxy[0])
    x_diff = abs(start_galaxy[1] - end_galaxy[1])
    return x_diff + y_diff

def solve(input):
    galaxies, empty_rows, empty_columns = transform_input(input)
    part_1 = sum([find_shortest_distance(*pair) for pair in combinations(calculate_galaxy_coords(galaxies, empty_rows, empty_columns, 2), 2)])
    part_2 = sum([find_shortest_distance(*pair) for pair in combinations(calculate_galaxy_coords(galaxies, empty_rows, empty_columns, 1_000_000), 2)])
    return part_1, part_2

input = open('11.in').read()
part_1, part_2 = solve(input)
print("Part 1:", part_1)
print("Part 2:", part_2)
