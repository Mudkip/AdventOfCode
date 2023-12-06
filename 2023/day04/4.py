def parse_input(input):
    return {
        list(filter(lambda x: x != '', card.split(" ")))[1]:
        {"count": 1, "numbers": [[num for num in numbers.split(" ") if num != ''] for numbers in numbers.split(" | ")]} for card, numbers in [line.split(": ") for line in input.splitlines()]
    }

def solve(input):
    input = parse_input(input)
    total = 0
    count_of_cards = 0
    for card in input:
        numbers = input[card]["numbers"]
        count_of_cards += input[card]["count"]

        scratch_set, winners_set = set(), set()
        scratch, winners = numbers
        scratch_set.update(scratch)
        winners_set.update(winners)
        matches = len(scratch_set & winners_set)
        if matches > 0:
            total += 2 ** (matches - 1)
            for x in range(1, matches + 1):
                input[str(int(card) + x)]["count"] += 1 * input[card]["count"]

    return total, count_of_cards

part_1, part_2 = solve(open("4.in").read())
print("Part 1:", part_1)
print("Part 2:", part_2)