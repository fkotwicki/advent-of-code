class MonkeyInspector
    Functions = {
        '*' => -> (left, right) { left * right },
        '+' => -> (left, right) { left + right }
    }

    def initialize(divideBy, lcm)
        @divideBy = divideBy
        @lcm = lcm
    end

    def inspect_item(operation, item)
        left = get_operand operation[0], item
        right = get_operand operation[2], item
        return (Functions[operation[1]].(left, right) / @divideBy) % @lcm
    end

    private

    def get_operand(operand, item)
        operand == 'old' ? item : operand.to_i
    end
end

class Monkey
    attr_reader :inspections

    def initialize(items, operation, test)
        @items = items
        @operation = operation
        @test = test
        @inspections = 0
    end

    def start_inspecting(inspector, &on_throw)
        until @items.empty?
            @inspections += 1
            item = inspector.inspect_item @operation, @items.shift
            on_throw.call (throw_item_to item), item
        end
    end

    def catch(item)
        @items << item
    end

    def divisibleBy
        @test[0]
    end

    def throw_item_to(item)
        return @test[1] if item % divisibleBy == 0
        return @test[2]
    end

end

def inspect_monkeys(input, divideBy, rounds)
    monkeys = File.readlines(input).each_slice(7).to_a.map { |segment|
        segment = segment.drop(1)
        items = segment[0].scan(/\d+/).map(&:to_i)
        operation = segment[1].split("=")[1].strip.split(" ")
        test = segment.drop(2).take(3).map { |s| s.scan(/\d+/).first.to_i }
        Monkey.new items, operation, test
    }
    lcm = monkeys.map { |m| m.divisibleBy }.reduce(1, :lcm)
    inspector = MonkeyInspector.new divideBy, lcm
    rounds.times do
        monkeys.each do |monkey|
            monkey.start_inspecting(inspector) do |to, item|
                monkeys[to].catch item
            end
        end
    end
    monkeys.map { |m| m.inspections }.sort.reverse.take(2).inject(:*)
end

input = "input.txt"
puts "Part one: #{inspect_monkeys(input, 3, 20)}"
puts "Part two: #{inspect_monkeys(input, 1, 10000)}"