f = open('25.in', 'r')
pub_card = int(f.readline().strip())
pub_door = int(f.readline().strip())

def guess(pub_key, loop_size):
    subject, v, loop_size = 7, 1, 0
    while v != pub_key:
        v = (v * 7) % 20201227
        loop_size += 1
    return loop_size


card_lsize = guess(pub_card, 10000)
door_lsize = guess(pub_door, 10000)

print(pow(pub_card, door_lsize, 20201227))