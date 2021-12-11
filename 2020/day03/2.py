map = open("1.in", "r").read().splitlines()

def slope(input, y_plus, x_plus):
    posx = 0
    posy = 0
    trees = 0
    while(posx < len(input)):
        if input[posx][posy % len(input[posx])] == "#":
            trees+=1
        posx += x_plus
        posy += y_plus
    
    return trees

map11 = slope(map, 1, 1)
map31 = slope(map, 3, 1)
map51 = slope(map, 5, 1)
map71 = slope(map, 7, 1)
map12 = slope(map, 1, 2)
print("Trees for right 1, down 1: %d" % map11)
print("Trees for right 3, down 1: %d" % map31)
print("Trees for right 5, down 1: %d" % map51)
print("Trees for right 7, down 1: %d" % map71)
print("Trees for right 1, down 2: %d" % map12)
print("Multiplied together: %d" % (map11*map31*map51*map71*map12))
