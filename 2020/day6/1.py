grps = open('1.in','r').read().split('\n\n')
nums = []
for grp in grps:
    lst = []
    grp = grp.replace("\n", "")
    for char in grp:
        if char not in lst:
            lst.append(char)
    nums.append(len(lst))
print(sum(nums))
