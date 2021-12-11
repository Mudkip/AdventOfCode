grps = open('1.in','r').read().split('\n\n')
nums = []
for grp in grps:
    sets = []
    lines = grp.splitlines()
    for line in lines:
        sets.append(set(line))
    for i in range(len(sets)):
        sets[0] = sets[0].intersection(sets[i])

    nums.append(len(sets[0]))
print(sum(nums))

