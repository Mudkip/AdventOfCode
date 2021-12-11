f = open("1.in", "r")
lines = f.read().splitlines()

for i in lines:
    for j in lines:
        if (int(i) + int(j)) == 2020:
            print(i, j)
