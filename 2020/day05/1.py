lines = open("1.in","r").read().splitlines()
high = 0b0000000000
for line in lines:
    binary = 0b0000000000
    for c in line:
        binary = binary << 1
        if c == "F" or c == "L":
            binary += 0b0
        else:
            binary += 0b1
        if(binary > high): high = binary

print(high)
