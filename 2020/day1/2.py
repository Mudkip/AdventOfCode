f = open("1.in", "r")
lines = f.read().splitlines()

for i in lines:
    for j in lines:
        for k in lines:
            if (int(i) + int(j) + int(k)) == 2020:
                print(i, j, k)
