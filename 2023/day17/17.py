from heapq import heappop, heappush

def parse_input(input):
    return [list(map(int, list(x))) for x in input.splitlines()]


def get_neighbors(grid, state, min_before_turn, max_before_turn):
    coords, direction, distance_straight = state
    y, x = coords

    neighbors = []
    
    match direction:
        case "right":
            if distance_straight >= min_before_turn:
                if y - 1 >= 0:
                    neighbors.append(((y - 1, x), "up", 0))
                if y + 1 < len(grid):
                    neighbors.append(((y + 1, x), "down", 0))
            if distance_straight < max_before_turn and x + 1 < len(grid[y]):
                neighbors.append(((y, x + 1), "right", distance_straight + 1))
        case "down":
            if distance_straight >= min_before_turn:
                if x - 1 >= 0:
                    neighbors.append(((y, x - 1), "left", 0))
                if x + 1 < len(grid[y]):
                    neighbors.append(((y, x + 1), "right", 0))
            if distance_straight < max_before_turn and y + 1 < len(grid):
                neighbors.append(((y + 1, x), "down", distance_straight + 1))
        case "left":
            if distance_straight >= min_before_turn:
                if y - 1 >= 0:
                    neighbors.append(((y - 1, x), "up", 0))
                if y + 1 < len(grid):
                    neighbors.append(((y + 1, x), "down", 0))
            if distance_straight < max_before_turn and x - 1 >= 0:
                neighbors.append(((y, x - 1), "left", distance_straight + 1))
        case "up":
            if distance_straight >= min_before_turn:
                if x - 1 >= 0:
                    neighbors.append(((y, x - 1), "left", 0))
                if x + 1 < len(grid[y]):
                    neighbors.append(((y, x + 1), "right", 0))
            if distance_straight < max_before_turn and y - 1 >= 0:
                neighbors.append(((y - 1, x), "up", distance_straight + 1))
    return neighbors

def djikstras(grid, min_before_turn = 0, max_before_turn = 2):
    rows, cols = len(grid), len(grid[0])
    start, end = (0, 0), (rows - 1, cols - 1)
    distances = {}
    queue = [(0, (start, "right", 0)), (0, (start, "down", 0))]

    while queue:
        cost, state = heappop(queue)
        if state in distances: continue

        coords, _, distance_straight = state
        if coords != end or distance_straight >= min_before_turn:
            distances[state] = cost

        for neighbor in get_neighbors(grid, state, min_before_turn, max_before_turn):
            if neighbor not in distances or new_cost < distances[neighbor]:
                y, x = neighbor[0]
                new_cost = cost + grid[y][x]
                heappush(queue, (new_cost, neighbor))

    return min(cost for (coords, *_), cost in distances.items() if coords == end)


def solve(input):
    grid = parse_input(input)
    part_1 = djikstras(grid, 0, 2)
    part_2 = djikstras(grid, 3, 9)
    return part_1, part_2

input = open("17.in").read()
part_1, part_2 = solve(input)
print("Part 1:", part_1)
print("Part 2:", part_2)