f = open("16.in", "r").read()
sections = f.split("\n\n")

rules = {}
for l in sections[0].splitlines():
    l = l.split(":")
    rules[l[0].replace(" ", "_")] = [tuple(int(x) for x in num.strip().split("-")) for num in l[1].split(" or ")]

s = 0
valid_tickets = []
for ticket in sections[2].splitlines()[1:]:
    valid = True
    ticket = ticket.strip().split(",")
    for value in ticket:
        correct = False
        value = int(value)
        for (min1, max1), (min2, max2) in rules.values():
            if (value >= min1 and value <= max1) or (value >= min2 and value <= max2):
                correct = True
        if not correct:
            s += value
            valid = False
            break
    if valid:
        valid_tickets.append(ticket)

zap = list(zip(*valid_tickets))
field_assoc = dict((r, []) for r in rules.keys())
for idx, nums in enumerate(zap):
    for rule, ((min1, max1), (min2, max2)) in rules.items():
        correct = True
        for num in nums:
            num = int(num)
            if (num < min1 or num > max1) and (num < min2 or num > max2):
                correct = False
                break
        if correct:
            field_assoc[rule].append(idx)

found = []
while(len(found) != len(rules.keys())):
    for rule, possibles in field_assoc.items():
        if(isinstance(possibles, list)):
            if len(possibles) == 1:
                field_assoc[rule] = possibles[0]
                found.append(possibles[0])
            else:
                field_assoc[rule] = list(filter(lambda possible: possible not in found, field_assoc[rule]))

my_ticket = sections[1].splitlines()[1].split(",")
product = 1
for field in field_assoc.keys():
    if "departure" in field:
        product *= int(my_ticket[field_assoc[field]])

print(s)
print(product)