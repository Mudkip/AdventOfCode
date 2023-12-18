

def parse_input(input, hex=False):
    input = input.splitlines()
    curr = (0, 0)
    points = []
    perimiter = 0
    for point in input:
        d, a, c = point.split(" ")

        if hex:
            a = hex_to_number(c[2:-2])
            d = num_to_direction(int(c[-2]))

        match d:
            case "R":
                curr = (curr[0] + int(a), curr[1])
            case "L":
                curr = (curr[0] - int(a), curr[1])
            case "U":
                curr = (curr[0], curr[1] + int(a))
            case "D":
                curr = (curr[0], curr[1] - int(a))
        perimiter += int(a)
        points.append(curr)
    return points, perimiter

def hex_to_number(hex):
    return int(hex, 16)

def num_to_direction(num):
    return ["R", "D", "L", "U"][num]

def calculate_internal_area(points):
    area = 0
    for i, coords in enumerate(points):
        if i + 1 == len(points): continue
        next_coords = points[i + 1]
        area += (coords[0] * next_coords[1] - coords[1] * next_coords[0])
    return abs(area) // 2

def calculate_area(area, perimeter):
    return area + perimeter // 2 + 1


def solve():
    points, perimeter = parse_input(open("18.in").read())
    part_1 = calculate_area(calculate_internal_area(points), perimeter)

    points, perimeter = parse_input(open("18.in").read(), hex=True)
    part_2 = calculate_area(calculate_internal_area(points), perimeter)

    return part_1, part_2

part_1, part_2 = solve()
print("Part 1:", part_1)
print("Part 2:", part_2)

