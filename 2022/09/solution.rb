Transposition = {
    :R => [1, 0],
    :L => [-1, 0],
    :U => [0, 1],
    :D => [0, -1]
}

def is_tail_touching?(tail_position, head_position)
    head_x, head_y = head_position
    (head_x - tail_position[0]).abs < 2 and (head_y - tail_position[1]).abs < 2
end

def normalize(num)
    return 0 if num == 0
    return -1 if num < 0
    return 1
end

def move_tail(head_position, tail_position)
    dx = normalize(head_position[0] - tail_position[0])
    dy = normalize(head_position[1] - tail_position[1])
    return [tail_position[0] + dx, tail_position[1] + dy]
end

def part_one(moves)
    tail_positions = [[0, 0]]
    head_position = [0, 0]
    tail_position = [0, 0]
    moves.each do |move|
        direction, steps = move    
        steps.times do
            head_position = [head_position, Transposition[direction]].transpose.map(&:sum)
            unless is_tail_touching? tail_position, head_position
                tail_position = move_tail head_position, tail_position
                tail_positions << tail_position
            end
        end        
    end
    tail_positions.uniq.size
end

moves = File.readlines("input.txt").map(&:strip).map { |line| 
    direction, steps = line.split()
    [direction.to_sym, steps.to_i]
}

puts "Part one: #{part_one moves}"
