lines = open("1.in","r").read().splitlines()
sid = []
for line in lines:
    binary = 0
    for c in line:
        binary = binary << 1
        if c == "F" or c == "L":
            binary += 0b0
        else:
            binary += 0b1
    sid.append(binary)

sid = sorted(sid)
sid_len = len(sid) - 1
for i in range(sid_len):
    if sid[i]+1 != sid[i+1]:
        print(sid[i]+1)
        break
