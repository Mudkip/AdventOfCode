adapters = open('1.in', 'r').read().splitlines()
adapters = [int(i) for i in adapters]
map = {adapters[i]: True for i in range(len(adapters))}
map[0] = True
map[max(adapters)+3] = True
counts = {1: 0, 3: 0}
jouls = 0
diff = 1
while jouls < max(map.keys()):
    if (jouls + diff) in map:
        counts[diff] += 1
        jouls = jouls + diff
        diff = 1
    else:
        diff += 1
print(counts[1] * (counts[3]))
