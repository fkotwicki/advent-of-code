def get_indexed_numbers(row):
    numbers = []
    current_number = ''
    index = 0
    for char in row:
        if char.isdigit():
            current_number += char
        elif current_number:
            numbers.append((index - len(current_number), current_number))
            current_number = ''
        index += 1 
    if current_number:
        numbers.append((index - len(current_number), current_number))         
    return numbers        


def has_adjacent_symbols(number, row_index, rows):
    previous_row = rows[row_index - 1] if row_index > 0 else []
    current_row = rows[row_index]
    next_row = rows[row_index + 1] if row_index < len(rows) - 1 else []

    start = max(number[0] - 1, 0)
    end = number[0] + len(number[1]) + 1

    has_symbols = False
    for row in [previous_row, current_row, next_row]:
        has_symbols = len([char for char in row[start:end] if not char.isdigit() and char != '.']) > 0
        if has_symbols:
            break

    return has_symbols

input = open('input.txt').read().splitlines()

def part_one(input):
    part_numbers_sum = 0
    for index, row in enumerate(input):
        part_numbers_sum += sum([int(number[1]) for number in get_indexed_numbers(row) if has_adjacent_symbols(number, index, input)])
    return part_numbers_sum

print(f'Part one: {part_one(input)}')

