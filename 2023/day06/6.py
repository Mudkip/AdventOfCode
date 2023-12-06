def parse_input(input):
    time, distance = input.splitlines()
    time = filter(lambda x: x != "", (time.split(":")[1].strip()).split(" "))
    distance = filter(lambda x: x != "", (distance.split(":")[1].strip()).split(" "))
    return time, distance

def solve(input, part_2 = False):
    ways_to_win = 1
    time, distance = parse_input(input)
    
    if part_2:
        time = [int("".join(time))]
        distance = [int("".join(distance))]

    for time, distance in zip(time, distance):
        time, distance = int(time), int(distance)
        won = 0
        for i in range(1, time + 1):
            rem_time = time - i
            if rem_time * i > distance:
                won += 1
        ways_to_win *= won
    return ways_to_win
            

print(solve(open("6.in", "r").read()))
print(solve(open("6.in", "r").read(), part_2=True))