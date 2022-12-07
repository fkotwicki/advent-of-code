def change_path(path, arg)
    if arg == ".."
        return path [0...-1]
    elsif arg == "/"
        return [arg]
    else
        return path << arg
    end
end

def calculate_dir_size(dirs, path, line)
    unless line.start_with?("dir")
        size = line.split()[0].to_i
        (0..path.size - 1).each do |i|
            dirs[path[..-i].join] += size
        end
    end
end

def prepare_dirs(input)
    dirs = Hash.new(0)
    path = []
    input.each do |line|
        if line.start_with?("$")
            command, arg = line.split().drop(1)
            if command == "cd"
                path = change_path(path, arg)
            end
        else
            calculate_dir_size(dirs, path, line)
        end
    end
    dirs
end

def part_one(input)
    prepare_dirs(input).values.select { |value| value <= 100000}.sum
end

def part_two(input)
    dirs = prepare_dirs(input)
    free_space = 70000000 - dirs["/"]
    dirs.values.drop(1).sort.detect { |value| free_space + value >= 30000000 }
end

input = File.readlines("input.txt").map(&:strip)

puts "Part one: #{part_one input}"
puts "Part two: #{part_two input}"