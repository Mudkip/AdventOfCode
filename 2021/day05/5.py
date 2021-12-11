import re
lines = open('5.in', 'r').read().splitlines()
pattern = '^(\d+),(\d+) -> (\d+),(\d+)$'

datapoints = [];
for line in lines:
    match = re.findall(pattern, line)
    datapoints.append([int(x) for x in match[0]])

def solve(input, diagonals=False):
    mape = {}
    for data in datapoints:
        x1, y1, x2, y2 = data
        if(x1 != x2 and y1 != y2 and diagonals):
            x = x1
            y = y1
            while(x != x2 and y != y2):
                if(x not in mape): mape[x] = {}
                mape[x][y] = (mape[x][y] if y in mape[x] else 0) + 1
                x = x+1 if x < x2 else x-1
                y = y+1 if y < y2 else y-1
                # Final iter simplification
                if(x == x2 and y == y2): 
                    if(x not in mape): mape[x] = {}
                    mape[x][y] = (mape[x][y] if y in mape[x] else 0) + 1
        else:
            if(x1 > x2): x1, x2 = x2, x1
            if(y1 > y2): y1, y2 = y2, y1

            if(x1 != x2 and y1 == y2):
                for x in range(x1, x2+1):
                    if x not in mape: mape[x] = {}
                    mape[x][y1] = (mape[x][y1] if y1 in mape[x] else 0) + 1
            elif(y1 != y2 and x1 == x2):
                for y in range(y1, y2+1):
                    if x1 not in mape: mape[x1] = {}
                    mape[x1][y] = (mape[x1][y] if y in mape[x1] else 0) + 1

    counter = 0
    for x in mape:
        for y in mape[x]:
            if mape[x][y] > 1:
                counter += 1
    
    return str(counter)

print("Part 1: " + solve(datapoints))
print("Part 2: " + solve(datapoints, True))