import re
lines = open('1.in','r').read().splitlines()

gold_related = set()
i = 0
while i < len(lines):
    holder, contents = lines[i].split(' contain ')
    contents = re.findall(r"(\w+ \w+) bag[s]?", contents.strip())
    holder = holder[:-5]
    print(holder, contents)
    if "shiny gold" in contents and holder not in gold_related:
        gold_related.add(holder)
        i = 0
        continue

    for item in contents:
        if item in gold_related and holder not in gold_related:
            gold_related.add(holder)
            i = 0
            continue
    i+=1

print(len(gold_related))
