def subsetSumExists(subset, num):
    for x in subset:
        for y in subset[1:]:
            if int(x) + int(y) == int(num): return True
    return False

def one():
    lines = open('1.in','r').read().splitlines()
    start = 0
    end   = 25
    while end < len(lines):
        preamble = lines[start:end]
        if not subsetSumExists(preamble, lines[end]):
            return int(lines[end])
            break
        start+=1
        end+=1

def two(required):
    lines = open('1.in','r').read().splitlines()
    sum = 0
    x   = 0
    c   = x + 1
    while sum != required:
        num = lines[x]
        sum = 0
        for i in lines[x:c]:
            sum += int(i)
        if sum == required:
                return lines[x:c]
        if sum > required:
                x += 1
                c = x + 1
        c += 1



def main():
    inv = one()
    lst = two(inv) 
    print("Invalid number: " + str(inv))
    print("List:")
    print(lst)
    print("Smallest num:" + min(lst))
    print("Largest num:" + max(lst))

main()
