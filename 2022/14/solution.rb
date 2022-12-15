require('set')

class Cave
    def initialize(points, start, width, height)
        @map = points
        @sand_positions = Set.new
        @start = start
        @width = width
        @height = height
        puts "Cave map size: #{@map.size}, width: #{@width}, height: #{@height}"
    end

    def simulate
        puts "simulation start" 
        start = Time.now
        sand_units = 0
        sand_position = @start
        while true
            sand_position = drop_sand(sand_position)
            
            if sand_position == :flow_out
                puts "simulation end after #{Time.now - start}s"
                return sand_units
            end

            if sand_position == @start
                sand_units += 1
                @sand_positions << sand_position
                @map << sand_position
                puts "simulation end after #{Time.now - start}s"
                return sand_units
            end
            
            if sand_position != nil
                sand_units += 1
                @sand_positions << sand_position
                @map << sand_position
                sand_position = @start
            end
        end
    end

    def print
        output = ""
        for y in 0..@height
            for x in 0..@width
                if @sand_positions.include? [x, y]
                    output << 'o'
                else
                    if @map.include? [x, y]
                        output << '#'
                    elsif @start_point == [x, y]
                        output << '+'
                    else
                        output << '.'
                    end
                end
            end
            output << "\n"
        end
        puts output
    end

    private

    def drop_sand(from)
        if from[1] >= @height
            return :flow_out
        end

        [0, -1, 1].each do |x|
            new_pos = [from[0] + x, from[1] + 1]
            if (@map.include? new_pos)
                next
            end
            return drop_sand(new_pos)
        end

        return from
    end

end

def parse_point(point)
    x, y = point.split(",")
    [x.to_i, y.to_i]
end

def parse_line(trace, &block)
    points = []
    trace.split(" -> ").map { |p| parse_point p }.reduce { |point, next_point|
        ([point[0], next_point[0]].min..[point[0], next_point[0]].max).to_a.each do |x|
            points <<[x, point[1]]
        end

        ([point[1], next_point[1]].min..[point[1], next_point[1]].max).to_a.each do |y|
            points << [point[0], y]
        end

        next_point
    }
    points
end

def part_one(input)
    points = File.readlines(input).flat_map { |trace| parse_line(trace.strip) }.map { |p|
        [p[0] - 500, p[1]]
    }
    min_x = points.map { |p| p[0] }.min.abs
    max_x = points.map { |p| p[0] }.max
    height = points.map { |p| p[1] }.max
    points = points.map { |p| [p[0] + min_x, p[1]]}.to_set
    cave = Cave.new points, [0 + min_x, 0], min_x + max_x, height
    result = cave.simulate
    cave.print
    result
end

def part_two(input) 
    points = File.readlines(input).flat_map { |trace| parse_line(trace.strip) }.to_set
    min_x = points.map { |p| p[0] }.min.abs
    max_x = points.map { |p| p[0] }.max
    height = points.map { |p| p[1] }.max + 2
    ((min_x - 200)..(max_x + 200)).each { |x| points << [x, height]}
    cave = Cave.new points, [500, 0], min_x + max_x, height
    cave.simulate
end

input = "input.txt"
puts "Part one: #{part_one input}"
puts "Part two: #{part_two input}"