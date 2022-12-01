def solution(n):
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
    sums.sort(reverse=True)
    return sum(sums[:n])

print(f"Part 1: {solution(1)}")
print(f"Part 2: {solution(3)}")
