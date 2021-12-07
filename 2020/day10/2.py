adapters = open('1.in', 'r').read().splitlines()
adapters = sorted([int(i) for i in adapters])
last = max(adapters) + 3
adapters.insert(0, 0)
adapters.append(last)
cache = {adapters[x]: 0 for x in range(len(adapters))} 
cache[last] = 1
for index in range(len(adapters) - 1, -1, -1):
    for i in range(1,4):
        prev = index + i
        if(prev < len(adapters)):
            diff = adapters[prev] - adapters[index]
            if diff <= 3:
                cache[adapters[index]] += cache[adapters[prev]]

print(cache[0])
