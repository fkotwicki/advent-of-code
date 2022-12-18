require ('set')

class Rocks   
    
    def initialize
        @rocks = [
            {:height => 1, :shape =>  [[0, 0], [1, 0], [2, 0], [3, 0]]},        #  _
            {:height => 3, :shape =>  [[1, 0], [0,1], [1,1], [2, 1], [1, 2]]},  #  +
            {:height => 3, :shape =>  [[0,0], [1,0], [2,0], [2, 1], [2, 2]]},   #  L
            {:height => 4, :shape =>  [[0, 0], [0, 1], [0, 2], [0, 3]]},        #  |
            {:height => 2, :shape =>  [[0, 0], [1, 0],[0, 1], [1, 1]]},         # [ ]
        ]
    end

    def next
        next_rock = @rocks.shift
        @rocks << next_rock
        next_rock
    end
end

class Chamber
    attr_reader :rocks_height

    def initialize(hot_gases)
        @hot_gases = hot_gases
        @width = 7
        @lines = [
            Set.new,
            Set.new,
            Set.new,
        ]
        @rocks_height = 0
    end

    def put_rock(rock)
        rock[:height].times { @lines << Set.new }
        rock = place rock
       
        while true
            rock = move_horizontal next_gase == '<' ? :left : :right, rock
            rested = move_down rock
            if rested != nil
                rock = rested
            else
                break
            end
        end

        @rocks_height = [(append_lines rock), @rocks_height].max 
        (@lines.size - @rocks_height).times { @lines.pop }
        3.times { @lines << Set.new }
    end

    def print(last = 0)
        ((@lines.size - 1).downto last > 0 ? (@lines.size - last) : 0).each { |row| 
            line = @lines[row]
            puts "#{row}:\t|#{(0..@width - 1).map { |col| 
                (line.include? [col, row]) ? '#' : '.'
            }.join}|"
        }
    end

    private
    
    def place(rock)
        rock[:shape].map { |cell| [cell[0] + 2, (@lines.size - rock[:height]) + cell[1]] }
    end

    def next_gase
        next_gase = @hot_gases.shift
        @hot_gases << next_gase
        next_gase
    end

    def move_horizontal(direction, rock)
        moved_rock = rock.map { |cell|
            x_diff = direction == :right ? 1 : (-1)
            [cell[0] + x_diff, cell[1]]
        }

        out_of_bounds_condition = (direction == :right) ? 
            -> (cell) { cell[0] > @width - 1 } : 
            -> (cell) { cell[0] < 0 }

        if moved_rock.any?(&out_of_bounds_condition)
             rock
        else
            unless collide? moved_rock
                moved_rock
            else
                rock
            end
        end
    end

    def move_down(rock)
        moved_rock = rock.map { |cell| 
            [cell[0], cell[1] - 1]
        }

        if moved_rock.any? { |cell| cell[1] < 0 } 
            nil
        else
            unless collide? moved_rock
                moved_rock
            else
                nil
            end
        end
    end

    def collide?(rock)
        points = rock
                .flat_map { |cell| @lines[cell[1]].select { |row| row[0] == cell[0] } }
                .select { |points| points != nil and points.size > 0 }
        (rock && points).size != 0
    end
    
    def append_lines(rock)
        rows = rock.map { |cell| cell[1] }
        rows.each do |row|
            line = @lines[row]
            if line != nil
                rock.select { |cell| cell[1] == row }.each do |cell|
                    line.add [cell[0], cell[1]]
                end
            end
        end

        return rows.max + 1
    end
end

def simulate(num_of_rocks)
    rocks = Rocks.new
    chamber = Chamber.new File.read("input.txt").strip.chars
    start_sim = Time.now
    num_of_rocks.times {
        chamber.put_rock rocks.next
    }
    end_sim = Time.now
    chamber.print 10
    "simulation ends after #{end_sim - start_sim}, rocks height: #{chamber.rocks_height}"
end

puts "Part one: #{simulate 2022}"
