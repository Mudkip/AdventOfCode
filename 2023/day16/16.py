import sys
sys.setrecursionlimit(1_000_000_000)

from enum import Enum
from multiprocessing import Pool, cpu_count

class Direction(Enum):
    UP = (-1, 0)
    DOWN = (1, 0)
    LEFT = (0, -1)
    RIGHT = (0, 1)

def parse_input(input):
    return [list(x) for x in input.splitlines()]

def navigate(grid, start, direction, visited = set()):
    y, x = start

    if ((y, x), direction) in visited or x < 0 or y < 0 or x >= len(grid[0]) or y >= len(grid):
        return visited

    visited.add(((y, x), direction))
    char = grid[y][x]
    match char:
        case "|":
            match direction:
                case Direction.LEFT | Direction.RIGHT:
                    new_up_coords = (y + Direction.UP.value[0], x + Direction.UP.value[1])
                    new_down_coords = (y + Direction.DOWN.value[0], x + Direction.DOWN.value[1])
                    return (navigate(grid, new_up_coords, Direction.UP, visited) | navigate(grid, new_down_coords, Direction.DOWN, visited))
        case "-":
            match direction:
                case Direction.UP | Direction.DOWN:
                    new_left_coords = (y + Direction.LEFT.value[0], x + Direction.LEFT.value[1])
                    new_right_coords = (y + Direction.RIGHT.value[0], x + Direction.RIGHT.value[1])
                    return (navigate(grid, new_left_coords, Direction.LEFT, visited) | navigate(grid, new_right_coords, Direction.RIGHT, visited))
        case "\\":
            match direction:
                case Direction.UP:
                    direction = Direction.LEFT
                case Direction.DOWN:
                    direction = Direction.RIGHT
                case Direction.LEFT:
                    direction = Direction.UP
                case Direction.RIGHT:
                    direction = Direction.DOWN
        case "/":
            match direction:
                case Direction.UP:
                    direction = Direction.RIGHT
                case Direction.DOWN:
                    direction = Direction.LEFT
                case Direction.LEFT:
                    direction = Direction.DOWN
                case Direction.RIGHT:
                    direction = Direction.UP

    new_coords = (y + direction.value[0], x + direction.value[1])
    return navigate(grid, new_coords, direction, visited)    

def count_energized(visited):
    return len(set(x[0] for x in visited))

def solve(input):
    grid = parse_input(input)
    part_1 = count_energized(navigate(grid, (0, 0), Direction.RIGHT, set()))

    args = []
    for x in range(len(grid[0])):
        args.append((grid, (0, x), Direction.DOWN, set()))
        args.append((grid, (len(grid) - 1, x), Direction.UP, set()))
    for y in range(len(grid)):
        args.append((grid, (y, 0), Direction.RIGHT, set()))
        args.append((grid, (y, len(grid[0]) - 1), Direction.LEFT, set()))

    with Pool(cpu_count()) as pool:
        results = pool.starmap(navigate, args)
    part_2 = max([count_energized(x) for x in results])

    return part_1, part_2

if __name__ == '__main__':
    part_1, part_2 = solve(open("16.in").read())
    print("Part 1:", part_1)
    print("Part 2:", part_2)