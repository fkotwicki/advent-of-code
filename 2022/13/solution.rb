input = File.readlines("input.txt").each_slice(3).to_a.map { |line| line[0, 2].map(&:strip).map { |line| eval(line) } }

def is_list?(el)
    el.is_a? Array
end

def is_number?(el)
    el.is_a? Integer
end

def compare(left, right)
    if is_number? left and is_number? right
        return left > right ? :gt : right > left ? :lt : :eq
    end

    if is_list? left or is_list? right
        left = [left] unless is_list? left
        right = [right] unless is_list? right

        max_index = [left.size, right.size].max
        for index in 0...max_index
            if left[index] == nil and (right[index] != nil or is_list? right[index])
                return :lt
            end
        
            if right[index] == nil and (left[index] != nil or is_list? left[index])
                return :gt
            end

            res = compare left[index], right[index]
            if res == :eq
                next
            end
                        
            return res
        end
    end

    return :eq
end

def part_one(input)
    input.map.with_index { |pair, index| compare(pair[0], pair[1]) == :lt ? index + 1 : 0 }.sum
end

def part_two(input)
    packet_a = [[2]]
    packet_b = [[6]]
    input.concat [[packet_a], [packet_b]]
    input.flat_map { |a| a }.sort {|a, b| 
        order = compare(a, b)
        order == :eq ? 0 : order == :lt ? -1 : 1
    }.map.with_index { |item, index| (item == packet_a or item == packet_b) ? index + 1 : 1}.inject(:*)
end

puts "Part one: #{ part_one input }"
puts "Part two: #{ part_two input }"