from collections import defaultdict

rankings = { "5K": 6, "4K":  5, "FH": 4, "3K": 3, "2P": 2, "1P": 1, "HC": 0 }
strength = defaultdict(int, { "T" : 10, "J": 11, "Q" : 12, "K" : 13, "A" : 14 })

def parse_input(input):
    lines = input.splitlines()
    hands = []
    for line in lines:
        hands.append(line.split(" "))
    return hands

def sort(plays):
    plays.sort(key=lambda x: (x[0], [strength[y] if not y.isdigit() else int(y) for y in x[1]]))

def solve(input, jokers=False):
    if jokers:
        strength["J"] = -1

    hands = parse_input(input)
    plays = []

    for (hand, bid) in hands:
        if jokers and "J" in hand:
            vars = [hand.replace("J", card) for card in "23456789TQKA"]
        else:
            vars = [hand]

        local_plays = []
        for var in vars:
            counts = defaultdict(int)
            for card in var:
                counts[card] += 1
            
            match len(counts):
                case 1: ranking = "5K"
                case 2:
                    if 4 in counts.values():
                        ranking = "4K"
                    else:
                        ranking = "FH"
                case 3:
                    if 3 in counts.values():
                        ranking = "3K"
                    else:
                        ranking = "2P"
                case 4: ranking = "1P"
                case 5: ranking = "HC"
            local_plays.append((rankings[ranking], var, bid, hand))

        sort(local_plays)
        (ranking, _, local_bid, local_hand) = local_plays[-1]
        plays.append((ranking, local_hand, local_bid))

    sort(plays)

    ans = 0
    for x in range(len(plays)):
        ans += int(plays[x][2]) * (x + 1)
    return ans

print("Part 1:", solve(open("7.in", "r").read()))
print("Part 2:", solve(open("7.in", "r").read(), True))