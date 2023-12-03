iter_pairs = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (-1, -1), (-1, 1), (1, -1)]

def parse_input(input):
    grid = []
    for line in input.splitlines():
        grid.append([".", *line, "."])
    grid.insert(0, ["." for _ in range(len(grid[0]))])
    grid.append(["." for _ in range(len(grid[0]))])
    return grid

def solve(input):
    sum_of_engine_parts = 0
    sum_of_gear_ratios = 0
    record = False
    engine_part = ""
    grid = parse_input(input)
    for x in range(1, len(grid) - 1):
        row = grid[x]
        for y in range(1, len(row) - 1):
            col = row[y]
            
            if col.isdigit():
                engine_part += col
                for x_add, y_add in iter_pairs:
                    char = grid[x + x_add][y + y_add]
                    if  char != "." and not char.isdigit():
                        record = True
                        break
            else:
                if record:
                    sum_of_engine_parts += int(engine_part)
                    record = False
                engine_part = ""

                if col == "*":
                    temp_engine_parts = set()
                    for x_add, y_add in iter_pairs:
                        char = grid[x + x_add][y + y_add]
                        if char.isdigit():
                            temp_no = [char]
                            move = -1
                            while grid[x + x_add][y + y_add + move].isdigit():
                                temp_no.insert(0, grid[x + x_add][y + y_add + move])
                                move -= 1
                            start = y + y_add + move
                            move = 1
                            while grid[x + x_add][y + y_add + move].isdigit():
                                temp_no.append(grid[x + x_add][y + y_add + move])
                                move += 1
                            end = y + y_add + move
                            # Technically, in my input all part numbers seemed to be unique.
                            # But just in case record the "number box" coordinates.
                            temp_engine_parts.add((int("".join(temp_no)), (x + x_add, start, end)))
                    if len(temp_engine_parts) == 2:
                        part_one, part_two = list(temp_engine_parts)
                        sum_of_gear_ratios += (list(part_one)[0] * list(part_two)[0])

    return sum_of_engine_parts, sum_of_gear_ratios

part_1, part_2 = solve(open("3.in").read())
print("Part 1: ", part_1)
print("Part 2:", part_2)