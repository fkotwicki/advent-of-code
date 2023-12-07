from functools import reduce
from operator import mul
from math import sqrt, ceil

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

def part_two(input):
    time = int(input[0].split(':')[1].strip().replace(' ', ''))
    distance = int(input[1].split(':')[1].strip().replace(' ', ''))
    return time + 1 - 2 * ceil((time - sqrt(time**2 - 4 * distance)) / 2) # quadratic formula

print(f'Part one {part_one(input)}')
print(f'Part two {part_two(input)}')

