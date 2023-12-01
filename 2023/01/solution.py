day_one = sum([list(map(lambda arr: arr[0]*10+arr[-1], [[int(c) for c in line if c.isdigit()]]))[0] for line in open('input.txt')])
print(f'Day one: {day_one}')

numbers = {'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'}
def replace(line):
    for key in numbers:
        line = line.replace(key, f'{key[0]}{numbers[key]}{key[-1]}', line.count(key))
    return line

day_two = sum([list(map(lambda arr: arr[0]*10+arr[-1], [[int(c) for c in replace(line) if c.isdigit()]]))[0] for line in open('input.txt')])
print(f'Day two {day_two}')