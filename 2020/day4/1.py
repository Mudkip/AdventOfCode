lines = open("1.in","r").read().splitlines()
valids = 0;
validate = {"byr": False, "iyr": False, "eyr": False, "hgt": False, "hcl": False, "ecl": False, "pid": False}
for line in lines:
    if line == "":
        if False not in validate.values():
            valids+=1
        validate = {"byr": False, "iyr": False, "eyr": False, "hgt": False, "hcl": False, "ecl": False, "pid": False}
    else:
        kvs = line.split()
        for kv in kvs:
            key, value = kv.split(":")
            validate[key] = True

print(valids) 
