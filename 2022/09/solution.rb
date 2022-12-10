Transposition = {
    :R => [1, 0],
    :L => [-1, 0],
    :U => [0, 1],
    :D => [0, -1]
}

def move_head(head, direction)
    [head, Transposition[direction]].transpose.map(&:sum)
end

def is_tail_touching?(head, tail)
    (head[0] - tail[0]).abs < 2 and (head[1] - tail[1]).abs < 2
end

def normalize(num)
    return 0 if num == 0
    return -1 if num < 0
    return 1
end

def move_tail(head, tail)
    dx = normalize(head[0] - tail[0])
    dy = normalize(head[1] - tail[1])
    return [tail[0] + dx, tail[1] + dy]
end

def part_one(moves)
    tail_positions = [[0, 0]]
    head = [0, 0]
    tail = [0, 0]
    moves.each do |move|
        direction, steps = move    
        steps.times do
            head = move_head head, direction
            unless is_tail_touching? head, tail
                tail = move_tail head, tail
                tail_positions << tail
            end
        end        
    end
    tail_positions.uniq.size
end

def part_two(moves)
    tail_positions = [[0, 0]]
    tail_position = [0, 0]
    rope = 10.times.map {[0, 0]}
    moves.each do |move|
        direction, steps = move    
        steps.times do
            rope[0] = move_head rope[0], direction
            for i in 1..rope.size - 1 do
                previous_knot = rope[i - 1]
                unless is_tail_touching? previous_knot, rope[i]
                    rope[i] = move_tail previous_knot, rope[i]
                    if i == rope.size - 1
                        tail_positions << rope[i]
                    end
                end
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
puts "Part two: #{part_two moves}"
