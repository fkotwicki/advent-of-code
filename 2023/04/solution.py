input = open('input.txt').read().splitlines()

def part_one(input):
    rows = [row.split(':')[1].split('|') for row in input]
    points = 0
    for row in rows:
        winning_numbers = set(map(lambda number: int(number), row[0].split()))
        numbers =  set(map(lambda number: int(number), row[1].split()))
        matching_numbers = winning_numbers & numbers
        if len(matching_numbers) > 0:
            points += (1 << len(matching_numbers) - 1)
    return points

print(f'Part one: {part_one(input)}')