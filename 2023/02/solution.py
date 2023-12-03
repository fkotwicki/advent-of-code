from functools import reduce
from operator import mul

def merge_dicts(dicts):
    return {key: value for dict in dicts for key, value in dict.items()}

def extract_cube_sets(game):
    return [merge_dicts(list(map(lambda cube: dict([(cube.split()[1], int(cube.split()[0]))]), cube_set))) for cube_set in [cube_set.split(',') for cube_set in game.split(':')[1].strip().split(';')]]

def part_one(games):
    ids = [] 
    for game in games:
        cube_sets = list(filter(lambda game_set: (game_set.get('red', 0) > 12 or game_set.get('green', 0) > 13 or game_set.get('blue', 0) > 14), extract_cube_sets(game)))
        if len(cube_sets) == 0:
            ids.append(int(game.split(':')[0].split()[1]))
    return sum(ids)

def part_two(games):
    power = 0
    for game in games:
        min_cubes = { 'blue': 0, 'green': 0, 'red': 0} 
        for cube_set in extract_cube_sets(game):
            min_cubes['blue'] = max(min_cubes['blue'], cube_set.get('blue', 0))
            min_cubes['green'] = max(min_cubes['green'], cube_set.get('green', 0))
            min_cubes['red'] = max(min_cubes['red'], cube_set.get('red', 0))
        power += reduce(mul, min_cubes.values())        
    return power

file = open('input.txt')
games = [line.removesuffix('\n') for line in file]

print(f'Part one: {part_one(games)}')
print(f'Part two: {part_two(games)}')