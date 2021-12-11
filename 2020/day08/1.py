lines = open('1.in','r').read().splitlines()

instructions = {}
accumulator  = 0
x = 0
while True:
    line = lines[x]
    op   = line[:3]
    sign = line[4:5]
    val  = line[5:]
     
    if x in instructions:
        print(accumulator)
        break
    else:
        instructions[x] = 1

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

    
