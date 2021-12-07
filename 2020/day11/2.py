def directionCoords(i, j, direction):
    if direction == "w":
        return i, j - 1
    if direction == "e":
        return i, j + 1
    if direction == "n":
        return i - 1, j
    if direction == "s":
        return i + 1, j
    if direction == "nw":
        return i - 1, j - 1
    if direction == "ne":
        return i - 1, j + 1
    if direction == "sw":
        return i + 1, j - 1
    if direction == "se":
        return i + 1, j + 1

def compare(seatMap, i, j, against, direction):
    while i >= 0 and i < len(seatMap) and j >= 0 and j < len(seatMap[i]) and seatMap[i][j] == ".":
        i, j = directionCoords(i, j, direction)

    if i >= 0 and i < len(seatMap) and j >= 0 and j < len(seatMap[i]):
        return seatMap[i][j] == against
    else:
        return against == "L"

def checkSeats(seatMap, i, j, checkAgainst):
    check = 0
    if j-1 >= 0:
        check = check + (compare(seatMap, i, j-1, checkAgainst, "w") and 1 or 0)
    else:
        check = check + (checkAgainst == "L" and 1 or 0)
    if j+1 < len(seatMap[i]):
        check = check + (compare(seatMap, i, j+1, checkAgainst, "e") and 1 or 0)
    else:
        check = check + (checkAgainst == "L" and 1 or 0)
    if i-1 >= 0:
        check = check + (compare(seatMap, i-1, j, checkAgainst, "n") and 1 or 0)
        if j-1 >= 0:
            check = check + (compare(seatMap, i-1, j-1, checkAgainst, "nw") and 1 or 0)
        else:
            check = check + (checkAgainst == "L" and 1 or 0)
        if j+1 < len(seatMap[i-1]):
            check = check + (compare(seatMap, i-1, j+1, checkAgainst, "ne") and 1 or 0)
        else:
            check = check + (checkAgainst == "L" and 1 or 0)
    else:
        check = check + (checkAgainst == "L" and 3 or 0)
    if i+1 < len(seatMap):
        check = check + (compare(seatMap, i+1, j, checkAgainst, "s") and 1 or 0)
        if j-1 >= 0:
            check = check + (compare(seatMap, i+1, j-1, checkAgainst, "sw") and 1 or 0)
        else:
            check = check + (checkAgainst == "L" and 1 or 0)
        if j+1 < len(seatMap[i+1]):
            check = check + (compare(seatMap, i+1, j+1, checkAgainst, "se") and 1 or 0)
        else:
            check = check + (checkAgainst == "L" and 1 or 0)
    else: 
        check = check + (checkAgainst == "L" and 3 or 0)
    return check

def simulateSeating(seatMap):
    changes = 0
    occupied = 0
    seatMapCopy = [x[:] for x in seatMap]
    for i in range(len(seatMap)):
        for j in range(len(seatMap[i])):
            if seatMap[i][j] == "L":
                if checkSeats(seatMap, i, j, "L") == 8:
                    seatMapCopy[i][j] = "#"
                    occupied += 1
                    changes += 1
            elif seatMap[i][j] == "#":
                occupied += 1
                if checkSeats(seatMap, i, j, "#") >= 5:
                    seatMapCopy[i][j] = "L"
                    occupied -= 1
                    changes += 1
    return changes, occupied, seatMapCopy


seatMapLines = open('1.in','r').read().splitlines()
seatMap = []
for line in seatMapLines:
    seatMap.append(list(line))

while True:
    changes, occupied, seatMap = simulateSeating(seatMap)
    if changes == 0:
        print(occupied)
        break
