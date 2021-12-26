lines = open("14.in", "r").read().splitlines()

def float_address(addresses):
    l = []
    for address in addresses:
        for idx, char in enumerate(address):
            if char == "X":
                ad1 = address.copy()
                ad2 = address.copy()
                ad1[idx] = "1"
                ad2[idx] = "0"
                l += [ad1, ad2]
                break
    if(len(l) != 0): return float_address(l)
    return ["".join(address) for address in addresses]


mem = {}
mem_2 = {}
for line in lines:
    inst, val = [x.strip() for x in line.split("=")]
    if inst == "mask":
        mask = [char for char in val]
    else:
        inst = inst[4:-1]
        inst2 = [char for char in format(int(inst), "#038b")]
        curr_mem = [char for char in format(int(val), "#038b")]
        for idx, char in enumerate(mask):
            if char == "X":
                inst2[idx+2] = "X"
            else: 
                curr_mem[idx+2] = char
                inst2[idx+2] = str(int(char) | int(inst2[idx+2]))

        curr_mem = "".join(curr_mem)
        mem[inst] = int(curr_mem, 2)
        for address in float_address([inst2]):
            mem_2[int(address, 2)] = int(val)

print(sum(mem.values()))
print(sum(mem_2.values()))