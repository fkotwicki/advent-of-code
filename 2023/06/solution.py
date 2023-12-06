from functools import reduce
from operator import mul

input = open('input.txt').read().splitlines()

def how_many_ways_to_win(time, distance):
    current_time = 0
    total_number = 0
    while current_time < time:
        current_time += 1
        speed = current_time
        time_to_move = time - current_time
        my_distance = time_to_move * speed
        if my_distance > distance:
            total_number += 1

    return total_number

def part_one(input):
    times = [int(time) for time in input[0].split(':')[1].strip().split()]
    distances = [int(distance) for distance in input[1].split(':')[1].strip().split()]
    time_and_distance = zip(times, distances)
    return reduce(mul, [how_many_ways_to_win(tad[0], tad[1]) for tad in time_and_distance])

print(f'Part one {part_one(input)}')

