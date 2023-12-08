import math
input = open('input.txt').read().split('\n\n')

def part_one(input):
    instructions = input[0]
    nodes = {}
    for node_line in input[1].split('\n'):
        node_parts = node_line.split('=')
        node_next_elements = node_parts[1].strip()[1:-1].split(',')
        nodes[node_parts[0].strip()] = (node_next_elements[0].strip(), node_next_elements[1].strip())
    
    instructions_length = len(instructions)
    current_instruction = 0
    current_node = nodes['AAA']
    total_instructions = 1
    while True:
        if current_instruction == instructions_length:
            current_instruction = 0

        current_node = current_node[0 if instructions[current_instruction] == 'L' else 1]
        if current_node == 'ZZZ':
            break

        current_node = nodes[current_node]
        current_instruction += 1
        total_instructions += 1

    return total_instructions

def part_two(input):
    instructions = input[0]
    nodes = {}
    start_nodes = []
    for node_line in input[1].split('\n'):
        node_parts = node_line.split('=')
        node_next_elements = node_parts[1].strip()[1:-1].split(',')
        node_key = node_parts[0].strip()
        node_value = (node_next_elements[0].strip(), node_next_elements[1].strip())
        nodes[node_key] = node_value
        if node_key.endswith('A'):
            start_nodes.append((node_value))
    
    total = []
    for start_node in start_nodes:
        current_instruction = 0
        current_node = start_node
        total_instructions = 1
        while True:
            if current_instruction == len(instructions):
                current_instruction = 0

            current_node = current_node[0 if instructions[current_instruction] == 'L' else 1]
            if current_node.endswith('Z'):
                break
        
            current_node = nodes[current_node]
            current_instruction += 1
            total_instructions += 1
        total.append(total_instructions)

    return math.lcm(*total)

print(f'Part one: {part_one(input)}')
print(f'Part two: {part_two(input)}')