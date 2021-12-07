lines = open('2.in','r').read().splitlines()

instructions = {}
accumulator  = 0
x = 0
while x < len(lines):
    line = lines[x]
    op   = line[:3]
    sign = line[4:5]
    val  = line[5:]
    if x in instructions:
        # Prints the instruction that starts the infinite loop, if there is one.
        print(lines[prev_x])
        break
    else:
        instructions[x] = 1

    prev_x = x
    if op == "acc":
        if sign == "+":
            accumulator += int(val)
        elif sign == "-":
            accumulator -= int(val)
    elif op == "jmp":
        if sign == "+":
            x += int(val)
        elif sign == "-":
            x -= int(val)
        continue
    x += 1

print(accumulator) 
