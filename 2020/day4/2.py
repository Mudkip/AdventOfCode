import re
lines = open("1.in","r").read().splitlines()
valids = 0;
eyeCols = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
rules = {
        "byr": lambda x: len(x) == 4 and int(x) >= 1920 and int(x) <= 2002,
        "iyr": lambda x: len(x) == 4 and int(x) >= 2010 and int(x) <= 2020,
        "eyr": lambda x: len(x) == 4 and int(x) >= 2020 and int(x) <= 2030,
        "hgt": lambda x: (x[-2:] == "cm" and int(x[:-2]) >= 150 and int(x[:-2]) <= 193) or (x[-2:] == "in" and int(x[:-2]) >= 59 and int(x[:-2]) <= 76),
        "hcl": lambda x: re.match(r"^#[0-9a-f]{6}$", x) is not None,
        "ecl": lambda x: x in eyeCols,
        "pid": lambda x: re.match(r"^[0-9]{9}$", x) is not None,
}
validate = {
        "byr": False,
        "iyr": False,
        "eyr": False,
        "hgt": False,
        "hcl": False,
        "ecl": False,
        "pid": False
}
for line in lines:
    if line == "":
        if False not in validate.values():
            valids+=1
        validate = {"byr": False, "iyr": False, "eyr": False, "hgt": False, "hcl": False, "ecl": False, "pid": False}
    else:
        kvs = line.split()
        for kv in kvs:
            key, value = kv.split(":")
            if key != "cid" and rules[key](value):
                validate[key] = True

print(valids) 
