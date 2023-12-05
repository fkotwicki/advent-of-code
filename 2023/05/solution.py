input = open('input.txt').read().split('\n\n')

def calculate_location(maps, dest):
    if not len(maps):
        return dest
    
    for ranges in maps[0]:
        if dest >= ranges[1] and dest <= (ranges[1] + (ranges[2] - 1)):
            dest = ranges[0] + (dest - ranges[1])
            break
    return calculate_location(maps[1::], dest)

def part_one(input):
    seeds = [int(seed) for seed in input[0].split(':')[1].split()]
    maps = []
    for m in input[1::]:
        ranges = [list(map(lambda r: int(r), range.split())) for range in m.split(':')[1].strip().split('\n')]
        maps.append(ranges)
    
    locations = []
    for seed in seeds:
        loc = calculate_location(maps, seed)
        locations.append(loc)

    return min(locations)

print(f'Part one: {part_one(input)}')