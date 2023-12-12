from functools import lru_cache

def parse_input(input, folds=1):
    return [(("?".join([record] * folds)), tuple(int(x) for x in (",".join([broken_groups] * folds)).split(","))) for record, broken_groups in (line.split(" ") for line in input.splitlines())]

@lru_cache
def possible_records(record, broken_groups, current_group_left = None):
    if record == "":
        if len(broken_groups) == 0 and (current_group_left == 0 or current_group_left is None):
            return 1
        else:
            return 0
    else:
        first, rest = record[0], record[1:]
        if first == ".":
            if current_group_left == 0 or current_group_left is None:
                return possible_records(rest, broken_groups)
            else:
                return 0
        elif first == "#":
            if current_group_left is None:
                if len(broken_groups) == 0:
                    return 0
                else:
                    return possible_records(rest, broken_groups[1:], broken_groups[0] - 1)
            elif current_group_left == 0:
                return 0
            else:
                return possible_records(rest, broken_groups, current_group_left - 1)
        elif first == "?":
            if current_group_left is None:
                if len(broken_groups) == 0:
                    return possible_records(rest, broken_groups)
                else:
                    return possible_records(rest, broken_groups) + possible_records(rest, broken_groups[1:], broken_groups[0] - 1)
            elif current_group_left == 0:
                return possible_records(rest, broken_groups)
            else:
                return possible_records(rest, broken_groups, current_group_left - 1)

def solve(input):
    part_1 = sum(possible_records(*line) for line in parse_input(input, folds = 1))
    part_2 = sum(possible_records(*line) for line in parse_input(input, folds = 5))
    return part_1, part_2

part_1, part_2 = solve(open('12.in').read())
print("Part 1:", part_1)
print("Part 2:", part_2)