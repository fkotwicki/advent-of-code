class CPU
    Cycles = {
        :noop => 1,
        :addx => 2
    }

    def initialize
        @register_x = 1
        @total_cycles = 0
    end

    def on_instruction_completed(&callback)
        @on_instruction_completed = callback
    end

    def process(instructions, &on_tick)
        instructions.each do |instruction|
            opcode, arg = instruction
            opcode_cycles = Cycles[opcode]
            while opcode_cycles > 0 do
                opcode_cycles -= 1
                @total_cycles += 1
                on_tick.call @total_cycles, @register_x
            end
            @register_x += arg
            @on_instruction_completed.call(@register_x) if @on_instruction_completed != nil
        end
    end
end

class Screen
    
    def initialize(max_height, max_width)
        @max_width = max_width
        @display = max_height.times.map { "" }
        @current_display_row = 0
    end

    def draw(pixel)
        @display[@current_display_row] << pixel
        if(@display[@current_display_row].size == @max_width)
            @current_display_row += 1
        end
    end

    def already_drawn?(*pos)
        pos.include? @display[@current_display_row].size
    end

    def print
        @display.join("\n")
    end
end

def part_one(instructions)
    signal_strengths = []
    cycles_to_analyze = [20, 60, 100, 140, 180, 220]
    cpu = CPU.new
    cpu.process instructions do |total_cycles, register_x|
        if cycles_to_analyze.include? total_cycles
            signal_strengths << total_cycles * register_x
        end
    end

    signal_strengths.sum
end

def part_two(instructions)
    screen = Screen.new 6, 40
    cpu = CPU.new
    
    sprite_position = 1
    cpu.on_instruction_completed do |register_x| 
        sprite_position = register_x
    end

    cpu.process instructions do |total_cycles, register_x|
        pixel = (screen.already_drawn?(sprite_position - 1, sprite_position, sprite_position + 1)) ? '#' : '.'
        screen.draw pixel
    end

    screen.print
end

instructions = File.readlines("input.txt").map(&:strip).map{ |line| [line.split()[0].to_sym, line.split()[1].to_i ] }

puts "Prt one: #{part_one(instructions)}"
puts "Part two:\n #{part_two(instructions)}"
