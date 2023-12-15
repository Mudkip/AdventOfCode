from collections import defaultdict

def hash(string):
    current = 0
    for char in string:
        current += ord(char)
        current *= 17
        current %= 256
    return current

def fill_boxes(instructions):
    boxes = defaultdict(dict)
    for instruction in instructions:
        is_add = "=" in instruction
        is_remove = "-" in instruction
        split_by = "=" if is_add else "-"
        label, focal_strength = instruction.split(split_by)

        label_hash = hash(label)
        if is_add: boxes[label_hash][label] = focal_strength
        if is_remove: boxes[label_hash].pop(label, None)
    return boxes

def focusing_power(boxes):
    total = 0
    for box_id, box in boxes.items():
        for lens_id, strength in enumerate(box.values(), 1):
            total += (box_id + 1) * (lens_id) * int(strength)
        
    return total

def solve():
    input = open("15.in").read().strip().split(",")
    part_1 = sum([hash(instruction) for instruction in input])
    part_2 = focusing_power(fill_boxes(input))
    return part_1, part_2

part_1, part_2 = solve()
print("Part 1:", part_1)
print("Part 2:", part_2)