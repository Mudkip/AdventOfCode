def parse_input(input):
    return [[int(num) for num in x] for x in (line.split(" ") for line in input.splitlines())]

def get_differences(sequence):
    new_sequence = []
    for i in range(len(sequence)):
        if i == len(sequence) - 1: break
        new_sequence.append(sequence[i+1] - sequence[i])
    return new_sequence

def solve(input):
    sequences = parse_input(input)
    l_total, r_total = 0, 0
    for seq_no in range(len(sequences)):
        next_sequence = sequences[seq_no]
        breakdown = [next_sequence]
        while any(next_sequence := get_differences(next_sequence)):
            breakdown.append(next_sequence)
        
        for i in range(len(breakdown)-1, 0, -1):
            breakdown[i-1].append(breakdown[i-1][-1] + breakdown[i][-1])
            breakdown[i-1].insert(0, breakdown[i-1][0] - breakdown[i][0])
                    
        r_total = r_total + breakdown[0][-1]
        l_total = l_total + breakdown[0][0]
    return r_total, l_total

part_1, part_2 = solve(open("9.in").read())
print("Part 1:", part_1)
print("Part 2:", part_2)