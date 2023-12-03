def parse_input(input):
    return input.readlines()

def parse_line(line):
    game_id, pulls = line.split(":")
    pulls = pulls.strip().split("; ")
    game_id = int(game_id.split(" ")[1])

    return game_id, pulls


def solve1(input):
    RED, GREEN, BLUE = 12, 13, 14
    good_games = []

    for line in input:
        game_id, pulls = parse_line(line)
        BAD_GAME = False
        for pull in pulls:
            USED_RED, USED_GREEN, USED_BLUE = 0, 0, 0
            dice = pull.split(", ")
            for die in dice:
                match die.split():
                    case [i, "red"]:
                        USED_RED += int(i)
                    case [i, "green"]:
                        USED_GREEN += int(i)
                    case [i, "blue"]:
                        USED_BLUE += int(i)
            if USED_RED > RED or USED_GREEN > GREEN or USED_BLUE > BLUE:
                BAD_GAME = True
                break
        if not BAD_GAME:
            good_games.append(game_id)
    return sum(good_games)
        
def solve2(input):
    min_cube_power = []

    for line in input:
        _, pulls = parse_line(line)
        MIN_RED, MIN_GREEN, MIN_BLUE = 0, 0, 0

        for pull in pulls:
            dice = pull.split(", ")
            for die in dice:
                match die.split():
                    case [i, "red"]:
                        MIN_RED = max([int(i), MIN_RED])
                    case [i, "green"]:
                        MIN_GREEN = max([int(i), MIN_GREEN])
                    case [i, "blue"]:
                        MIN_BLUE = max([int(i), MIN_BLUE])
        min_cube_power.append(MIN_RED * MIN_GREEN * MIN_BLUE)
    return sum(min_cube_power)


print("Part 1:", solve1(parse_input(open("2.in"))))
print("Part 2:", solve2(parse_input(open("2.in"))))
