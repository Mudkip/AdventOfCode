f = open('13.in', 'r')
depart = int(f.readline().strip())
buses = [x if x == 'x' else int(x) for x in f.readline().strip().split(",")]
def earliest(timestamp, buses):
    while(True):
        for bus in buses:
            if (bus != 'x') and (timestamp % bus) == 0:
                return (timestamp, bus)
        timestamp += 1

f = earliest(depart, buses)
print("Part 1: %d" % ((f[0]-depart) * f[1]))


def earliest_chain(timestamp, buses):
    timestamp = 0
    add = 1
    bus = 0
    while(True):
        if (buses[bus] == "x"):
            bus += 1
            continue
        if ((timestamp + bus) % buses[bus]) == 0:
            add *= buses[bus]
            bus += 1
        if bus == len(buses):
            break
        timestamp += add

    return timestamp
            

print("Part 2: %d" % earliest_chain(0, buses))