import re
regex = r"(\d+)-(\d+) ([a-z]): ([a-z]+)"
lines = open("1.in", "r").read().splitlines()

invalid = 0
valid = 0
for line in lines:
    reg = re.search(regex, line)
    pos_1 = int(reg.group(1)) - 1
    pos_2 = int(reg.group(2)) - 1
    letter  = reg.group(3)
    passwd  = reg.group(4)

    passwd_pos1 = passwd[pos_1]
    passwd_pos2 = passwd[pos_2]

    if (passwd_pos1 == letter) ^ (passwd_pos2 == letter):
        valid += 1
    else:
        invalid += 1

print(str(invalid) + " invalid passwords counted")
print(str(valid) + " valid passwords counted")
