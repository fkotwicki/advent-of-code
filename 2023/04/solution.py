input = open('input.txt').read().splitlines()

def part_one(input):
    rows = [row.split(':')[1].split('|') for row in input]
    points = 0
    for row in rows:
        matching_numbers = {int(number) for number in row[0].split()} & {int(number) for number in row[1].split()}
        if len(matching_numbers) > 0:
            points += (1 << len(matching_numbers) - 1)
    return points
        
def part_two(input):
    rows = [row.split(':')[1].split('|') for row in input]
    totals = dict((no + 1, 1) for no in range(len(input)))
    for index, row in enumerate(rows):
        matching_numbers = {int(number) for number in row[0].split()} & {int(number) for number in row[1].split()}
        card_no = index + 1
        card_copies = [*range(card_no + 1, card_no + 1 + len(matching_numbers))]
        total = totals[card_no]
        for cc in card_copies:
            totals[cc] += total
  
    return sum(totals.values())

print(f'Part one: {part_one(input)}')
print(f'Part two: {part_two(input)}')