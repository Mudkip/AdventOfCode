from math import lcm

MAGIC_MODULES_THAT_I_HAD_TO_INSPECT_INPUT_FOR = {"zc": 0, "xt": 0, "fp": 0, "mk": 0}

def parse_input(input):
    m = {}
    input = input.splitlines()
    ts = []
    for line in input:
        n, t = line.split(" -> ")
        fs = n[0]
        ls = t.split(", ")
        for l in ls:
            ts.append((n[1:], l))
        if fs == "%":
            m[n[1:]] = (fs, 0, ls)
        elif fs == "&":
            m[n[1:]] = (fs, {}, ls)
        else:
            m[n] = (n, 0, ls)

    for f, t in ts:
        if t not in m:
            m[t] = (t, 0, [])
        else:
            if m[t][0] == "&":
                m[t][1][f] = 0

    return m

def solve(input, times):
    m = parse_input(input)
    cs = [0, 0]
    for bp in range(times):
        if all(MAGIC_MODULES_THAT_I_HAD_TO_INSPECT_INPUT_FOR.values()):
            return lcm(*MAGIC_MODULES_THAT_I_HAD_TO_INSPECT_INPUT_FOR.values())
        q = [("broadcaster", 0, "button")]
        while q:
            n, s, f = q.pop(0)
            cs[s] += 1
            t, st, dls = m[n]
            if t == "broadcaster":
                for d in dls:
                    q.append((d, s, n))
            elif t == "%":
                if s == 0:
                    new_st = int(not st)
                    m[n] = (t, new_st, dls)
                    if new_st == 1:
                        for d in dls:
                            q.append((d, 1, n))
                    else:
                        for d in dls:
                            q.append((d, 0, n))
            elif t == "&":
                m[n][1][f] = s
                if all(m[n][1].values()):
                    for d in dls:
                        q.append((d, 0, n))
                else:
                    if n in (list(MAGIC_MODULES_THAT_I_HAD_TO_INSPECT_INPUT_FOR.keys())):
                        MAGIC_MODULES_THAT_I_HAD_TO_INSPECT_INPUT_FOR[n] = bp+1
                    for d in dls:
                        q.append((d, 1, n))
    return cs[0] * cs[1]

input = open("20.in").read()
part_1 = solve(input, 1000)
part_2 = solve(input, 1_000_000_000)
print("Part 1:", part_1)
print("Part 2:", part_2)