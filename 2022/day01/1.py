input = open("1.in", "r")
sums = []
currSum = 0
for line in input.readlines():
    if line == "\n":
        sums.append(currSum)
        currSum = 0
    else:
        num = int(line.strip())
        currSum += num
sums.sort()
print(f"Part 1: {sums[-1]}")
print(f"Part 1: {sum(sums[-3:])}")
