def parseInputs():
    stacks, instructions = {}, []
    for line in open("5.in", "r").read().splitlines():
        if (line.strip().startswith('1')): continue
        if (line.startswith('move')): 
            instructions.append(list((int(x) if x.isdigit() else x for x in line.split(' ')))[1::2])
            continue
        for i in range(0, len(line), 4):
            index = (i//4)+1
            crate = line[i+1:i+2].strip()
            if index not in stacks: stacks[index] = []
            if crate != '': stacks[index].insert(0, crate)
    return stacks, instructions

def solve(part2=False):
    queue = []
    stacks, instructions = parseInputs()
    for amount, fromStack, toStack in instructions:
        for _ in range(amount, 0, -1):
            popped = stacks[fromStack].pop()
            if part2: queue.append(popped)
            else: queue.insert(0, popped)
        while len(queue) != 0: stacks[toStack].append(queue.pop())
    return "".join(map(lambda idx: stacks[idx][-1], stacks))

print(f"Part 1: {solve(part2=False)}")
print(f"Part 1: {solve(part2=True)}")