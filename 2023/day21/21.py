import numpy as np

def parse_input(input):
    input = [list(x) for x in input.splitlines()]
    start = None
    for i in range(len(input)):
        for j in range(len(input[i])):
            if input[i][j] == "S":
                start = (i,j)
                break
    return input, start

def find_steps(input, start, steps):
    q = set()
    q.add(start)
    while steps > 0:
        steps -= 1
        new_q = set()
        for x, y in q:
            for dx, dy in ((1,0), (-1,0), (0,1), (0,-1)):
                nx, ny = (x + dx), (y + dy)
                cx, cy = nx % 131, ny % 131
                if input[cx][cy] != "#":
                    new_q.add((nx, ny))
        q = new_q
    return len(q)

def solve(input):
    input, start = parse_input(input)
    part_1 = find_steps(input, start, 64)


    i_1 = find_steps(input, start, 65)
    i_2 = find_steps(input, start, 196)
    i_3 = find_steps(input, start, 327)
    n = 26501365 // 131
    coef = [[0,0,1],[1,1,1],[4,2,1]]
    x = np.linalg.solve(coef, [i_1, i_2, i_3])
    part_2 = (x[0] * n**2 + x[1] * n + x[2]).astype(np.int64)
    return part_1, part_2

part_1, part_2 = solve(open("21.in").read())
print("Part 1:", part_1)
print("Part 2:", part_2)