from collections import defaultdict

def hash(string):
    current = 0
    for char in string:
        current += ord(char)
        current *= 17
        current %= 256
    return current

def fill_boxes(instructions):
    boxes = defaultdict(list)
    for instruction in instructions:
        is_add = "=" in instruction
        is_remove = "-" in instruction
        split_by = "=" if is_add else "-"
        label, value = instruction.split(split_by)
        box = hash(label)

        box_contents = {x[0]: x for x in boxes[box]}
        if is_add:
            if label not in box_contents:
                boxes[box].append((label, value))
            else:
                curr_index = boxes[box].index(box_contents[label])
                boxes[box][curr_index] = (label, value)
        if is_remove:
            if label in box_contents:
                boxes[box].remove(box_contents[label])

    return boxes

def focusing_power(boxes):
    total = 0
    for box_id, box in boxes.items():
        for lens_id, lens in enumerate(box):
            total += (box_id + 1) * (lens_id + 1) * int(lens[1])
        
    return total

def solve():
    input = open("15.in").read().strip().split(",")
    part_1 = sum([hash(part) for part in input])
    part_2 = focusing_power(fill_boxes(input))
    return part_1, part_2

part_1, part_2 = solve()
print("Part 1:", part_1)
print("Part 2:", part_2)