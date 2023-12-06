def parse_input(input):
    sections = input.split("\n\n")
    seeds = [int(x) for x in sections[0][7:].split(" ")]
    conversions = {}
    for i in range(1, len(sections)):
        lines = sections[i].split("\n")
        conversion = tuple(lines[0][:-5].split("-to-"))
        conversions[conversion] = []
        for line in lines[1:]:
            guide = line.split(" ")
            conversion_obj = {"src": int(guide[1]), "dst": int(guide[0]), "rng": int(guide[2])}
            conversions[conversion].append(conversion_obj)
    return seeds, conversions

def recursive_map_1(conversions, seed, src_category, dst_category):
    for ((src, dst), mappings) in conversions.items():
        if src_category == src:
            for mapping in mappings:
                if seed in range(mapping["src"], mapping["src"] + mapping["rng"]):
                    seed = mapping["dst"] + (seed - mapping["src"])
                    break
            if dst_category == dst:
                return seed
            else:
                return recursive_map_1(conversions, seed, dst, dst_category)
            
def recursive_map_2(conversions, seeds_to_check, src_category, dst_category):
    if src_category == dst_category:
        return seeds_to_check
    for ((src, dst), mappings) in conversions.items():
        if src_category == src:
            new_seeds_to_check = []
            for mapping in mappings:
                dst_start = mapping["dst"]
                src_start = mapping["src"]
                src_end = src_start + mapping["rng"]
                non_modified = []
                while seeds_to_check:
                    (seed_start, seed_end) = seeds_to_check.pop()
                    intersection = (max(seed_start, src_start) - src_start + dst_start, min(seed_end, src_end) - src_start + dst_start)
                    before = (seed_start, min(seed_end, src_start))
                    after = (max(seed_start, src_end), seed_end)
                    if intersection[0] < intersection[1]:
                        new_seeds_to_check.append(intersection)
                    if before[0] < before[1]:
                        non_modified.append(before)
                    if after[0] < after[1]:
                        non_modified.append(after)
                seeds_to_check = non_modified
            return recursive_map_2(conversions, new_seeds_to_check + seeds_to_check, dst, dst_category)
        
def solve_1(input):
    seeds, conversions = parse_input(input)
    locations = set()
    for seed in seeds:
        locations.add(recursive_map_1(conversions, seed, "seed", "location"))
    return min(list(locations))

def solve_2(input):
    seeds, conversions = parse_input(input)
    it = iter(seeds)
    seeds_to_check = []
    for seed in it:
        start, end = seed, seed + next(it)
        seeds_to_check.append((start, end))
    return min(recursive_map_2(conversions, seeds_to_check, "seed", "location"))[0]


part_1 = solve_1(open("5.in").read())
part_2 = solve_2(open("5.in").read())

print("Part 1:", part_1)
print("Part 2:", part_2)