puzzle = "20,9,11,0,1,2"
puzzle = puzzle.split(",")

def game(steps):
    spoken = {}
    for i in range(1, steps+1):
        if i <= len(puzzle): 
            last_spoken = int(puzzle[i-1])
        else:
            if first:
                last_spoken = 0
            else:
                last_spoken = spoken[last_spoken][1] - spoken[last_spoken][0]
        
        first = False if last_spoken in spoken else True
        spoken[last_spoken] = (spoken[last_spoken][1] if last_spoken in spoken else 0, i)
    return last_spoken


print(game(2020))
print(game(30000000))