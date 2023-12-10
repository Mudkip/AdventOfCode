MOVES = {
    '|': [(-1, 0), (1, 0)],
    '-': [(0, -1), (0, 1)],
    'L': [(-1, 0), (0, 1)],
    'J': [(-1, 0), (0, -1)],
    '7': [(1, 0), (0, -1)],
    'F': [(1, 0), (0, 1)]
}

def transform_input(input):
    grid = [[x for x in line] for line in input.splitlines()]

    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if grid[y][x] == 'S':
                starting_pos = (y, x)
    
    return grid, starting_pos

def bfs(grid, start_pos):
    queue = [start_pos]
    visited = {start_pos}
    distance = {start_pos: 0}

    while queue:
        y, x = queue.pop(0)
        dist = distance[(y, x)]
        possible_moves = MOVES[grid[y][x]]
        for dy, dx in possible_moves:
            new_y = y + dy
            new_x = x + dx
            if 0 <= new_y < len(grid) and 0 <= new_x < len(grid[0]):
                if (new_y, new_x) not in visited:
                    queue.append((new_y, new_x))
                    visited.add((new_y, new_x))
                    distance[(new_y, new_x)] = dist + 1

    return max(distance.values()), visited

def replace_unvisited(grid, visited):
    for y in range(len(grid)):
        for x in range(len(grid[y])):
            if (y, x) not in visited:
                grid[y][x] = '.'
    return grid

def blow_up(grid):
    new_grid = []
    for y in range(len(grid)):
        new_grid.append([])
        new_grid.append([])
        for x in range(len(grid[y])):
            if grid[y][x] == '|':
                new_grid[-2].append('|')
                new_grid[-2].append('.')
                new_grid[-1].append('|')
                new_grid[-1].append('.')
            elif grid[y][x] == '-':
                new_grid[-2].append('-')
                new_grid[-2].append('-')
                new_grid[-1].append('.')
                new_grid[-1].append('.')
            elif grid[y][x] == 'L':
                new_grid[-2].append('L')
                new_grid[-2].append('-')
                new_grid[-1].append('.')
                new_grid[-1].append('.')
            elif grid[y][x] == 'J':
                new_grid[-2].append('J')
                new_grid[-2].append('.')
                new_grid[-1].append('.')
                new_grid[-1].append('.')
            elif grid[y][x] == '7':
                new_grid[-2].append('7')
                new_grid[-2].append('.')
                new_grid[-1].append('|')
                new_grid[-1].append('.')
            elif grid[y][x] == 'F':
                new_grid[-2].append('F')
                new_grid[-2].append('-')
                new_grid[-1].append('|')
                new_grid[-1].append('.')
            elif grid[y][x] == '.':
                new_grid[-2].append('.')
                new_grid[-2].append('.')
                new_grid[-1].append('.')
                new_grid[-1].append('.')
    return new_grid

def flood_fill(grid, start_pos):
    queue = [start_pos]
    visited = {start_pos}

    while queue:
        y, x = queue.pop(0)
        grid[y][x] = 'O'
        possible_moves = [(y-1, x), (y+1, x), (y, x-1), (y, x+1)]
        for new_y, new_x in possible_moves:
            if 0 <= new_y < len(grid) and 0 <= new_x < len(grid[0]):
                if (new_y, new_x) not in visited:
                    if grid[new_y][new_x] == '.':
                        queue.append((new_y, new_x))
                        visited.add((new_y, new_x))
    return grid

def count_leftovers(grid):
    count = 0
    for y in range(0, len(grid), 2):
        for x in range(0, len(grid[0]), 2):
            if grid[y][x] == '.':
                count += 1
    return count

def solve(input):
    grid, starting_pos = transform_input(input)

    y, x = starting_pos
    grid[y][x] = "-" # Change this lol. I am not writing out the logic for this.

    part_1, visited = bfs(grid, starting_pos)
    grid = blow_up(replace_unvisited(grid, visited))
    for start in [(0,0), (0, len(grid[0])-1), (len(grid)-1, 0), (len(grid)-1, len(grid[0])-1)]:
        grid = flood_fill(grid, start)

    return part_1, count_leftovers(grid)

part_1, part_2 = solve(open('10.in').read())
print("Part 1:", part_1)
print("Part 2:", part_2)