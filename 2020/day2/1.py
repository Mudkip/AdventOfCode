import re
regex = r"(\d+)-(\d+) ([a-z]): ([a-z]+)"
lines = open("1.in", "r").read().splitlines()

invalid = 0
valid = 0
for line in lines:
    reg = re.search(regex, line)
    minimum = int(reg.group(1))
    maximum = int(reg.group(2))
    letter  = reg.group(3)
    passwd  = reg.group(4)

    count = passwd.count(letter)
    if count < minimum or count > maximum:
        invalid += 1
    else: valid += 1
print(str(invalid) + " invalid passwords counted")
print(str(valid) + " valid passwords counted")
