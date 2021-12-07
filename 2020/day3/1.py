lines = open("1.in", "r").read().splitlines()
posy = 0
trees = 0

for line in lines:
    if line[posy % len(line)] == "#":
        trees+=1
    posy+=3

print(trees)
