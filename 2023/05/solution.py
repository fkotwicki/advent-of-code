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
          
def calc_overlap(rng, other):
    min1, len1 = rng
    min2, len2 = other
    left = max(min1, min2)
    right = min(min1 + len1, min2 + len2)
    if left < right:
      result = []
      if min1 < left:
        result.append(((min1, left - min1), False))
      if min1 + len1 > right:
        result.append(((right, min1 + len1 -  right), False))
      result.append(((left, right - left), True))
      return result
    else:
      return [(rng, False)]
              
def calculate_range_locations(maps, dest):
    if not len(maps):
        return dest
    new_dest = []
    new_ranges = dest
    for ranges in maps[0]:
        not_mapped = []
        for new_range in new_ranges:
           result = calc_overlap(new_range, (ranges[1], ranges[2]))
           for rng, overlaps in result:
              if overlaps:
                 new_dest.append((ranges[0] + (rng[0] - ranges[1]), rng[1]))
              else:
                 not_mapped.append(rng)
        new_ranges = not_mapped
    new_dest += new_ranges    
    dest = new_dest
    return calculate_range_locations(maps[1::], dest)

def part_two(input):
    seed_pairs = iter([int(seed) for seed in input[0].split(':')[1].split()])
    seeds = []
    for s1, s2 in zip(seed_pairs, seed_pairs):
        seeds += [(s1, s2)]

    maps = []
    for m in input[1::]:
        ranges = [list(map(lambda r: int(r), range.split())) for range in m.split(':')[1].strip().split('\n')]
        maps.append(ranges)
    
    locations = []
    for seed in seeds:
        locations += calculate_range_locations(maps, [seed])

    return min(locations)[0]

print(f'Part one: {part_one(input)}')
print(f'Part two: {part_two(input)}')