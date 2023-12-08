from math import lcm

def parse_input(input):
    lines = input.splitlines()
    instructions = lines[0]
    network = lines[2:]

    node_instructions = {}
    for node in network:
        value, children = node.split(" = (")
        left, right = children[0:-1].split(", ")
        node_instructions[value] = (left, right)

    return instructions, node_instructions

def navigate(instructions, node_instructions, from_node, eval):
    steps = 0
    while eval(from_node) == False:
        instruction_number = steps % len(instructions)
        instruction = instructions[instruction_number]
        from_node = node_instructions[from_node][0 if instruction == "L" else 1]
        steps += 1
    return steps

def part_1(input):
    instructions, node_instructions = parse_input(input)
    return navigate(instructions, node_instructions, "AAA", lambda node: node == "ZZZ")

def part_2(input):
    instructions, node_instructions = parse_input(input)
    start_nodes = [node for node in node_instructions if node.endswith("A")]
    return lcm(*[navigate(instructions, node_instructions, node, lambda node: node.endswith("Z")) for node in start_nodes])

read = open("8.in").read()
print("Part 1:", part_1(read))
print("Part 2:", part_2(read))