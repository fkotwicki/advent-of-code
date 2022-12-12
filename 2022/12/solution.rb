require 'set'

class Point
    def initialize(x, y, elevation)
        @x = x
        @y = y
        @elevation = elevation
    end

    def pos
        [@x, @y]
    end

    def elevation
        @elevation
    end

    def neighbors(height_map, &elevation_diff)
        neighbors = []
        [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |pos|
            n = height_map[[@x + pos[0], @y + pos[1]]]
            if n != nil and elevation_diff.call(n, @elevation)
                neighbors << n
            end
        end
        neighbors
    end
    
end

def height_map(input)
    height_map = { :points => { } }
    File.readlines(input).map(&:strip).each_with_index { |line, y|    
        line.chars.each_with_index { |char, x|
            start = char == 'S'
            dest = char == 'E'
            char = 'a' if start
            char = 'z' if dest
            point = Point.new x, y, char.ord
            if start; height_map[:start] = point; end
            if dest; height_map[:dest] = point; end
            height_map[:points][point.pos] = point
        }
    }
    return height_map
end

def find_shortest_path(start, dest, points, &elevation_diff)
    seen = Set.new
    active = [[0, start]]
    while active.size > 0
        steps, current = active.shift
        if current == dest
            return steps
        end
        unless seen.include? current
            seen << current
            current.neighbors(points, &elevation_diff).each do |n|
                active << [steps + 1, n]
            end
        end
    end

    return nil
end

def part_one(input)
    height_map = height_map input
    start = height_map[:start]
    dest = height_map[:dest]
    elevation_diff = -> (neighbor, current_elevation) {
        (neighbor.elevation - current_elevation) <= 1
    }
    find_shortest_path start, dest, height_map[:points], &elevation_diff
end

def part_two(input)
    height_map = height_map input
    elevation_diff = -> (neighbor, current_elevation) {
        (current_elevation - neighbor.elevation) <= 1
    }
    height_map = height_map input
    start = height_map[:dest]
    height_map[:points].values
        .select { |value| value.elevation == 97 }
        .map { |dest| find_shortest_path start, dest, height_map[:points], &elevation_diff }
        .select { |s| s != nil}
        .min
end

puts "Part one: #{part_one("input.txt")}"
puts "Part two: #{part_two("input.txt")}"
