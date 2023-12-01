num_map = {
    "one": "1", "two": "2", "three": "3",
    "four": "4", "five": "5", "six": "6",
    "seven": "7", "eight": "8", "nine": "9"
}

def parse_input(input):
    return input.readlines()

def solve1(input):
    total = 0
    first, last = 0, 0
    for line in input:
        filtered = list(filter(str.isdigit, line))
        if len(filtered) == 1:
            first, last = filtered[0], filtered[0]
        else:
            first, *_,  last = filtered
        total += int(first + last)
    return total
    

def solve2(input):
    total = 0
    for line in input:
        digits_found = []
        for index in range(len(line)):
            if line[index].isdigit():
                digits_found.append(line[index])
            for key, value in num_map.items():
                if index + len(key) > len(line):
                    continue
                if line[index:index+len(key)] == key:
                    digits_found.append(value)
        if len(digits_found) == 1:
            first, last = digits_found[0], digits_found[0]
        else:
            first, *_, last = digits_found
        total += int(first + last)
    return total

print("Part 1:", solve1(parse_input(open("1.in"))))
print("Part 2:", solve2(parse_input(open("1.in"))))