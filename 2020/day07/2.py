import re
lines = open('1.in','r').read().splitlines()

def get_contents(bag, count = 0):
    bag_line = [line for line in lines if (bag + " bags contain") in line][0]
    return re.findall(r"([\d+]) ([a-z\s]+) bag", bag_line)

def sum_up(contents):
    if len(contents) == 0: return 0 
    c = 0
    for count, type in contents:
        c += int(count)
        c += sum_up(get_contents(type)) * int(count)
    return c

gold = get_contents("shiny gold")
print(sum_up(gold))
