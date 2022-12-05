input = File.read("input.txt").split("\n\n")

def prepare_stacks(input)
    input
        .first
        .split("\n")
        .map { |s| s.chars.each_slice(4).map{ |s| s[1].strip } }
        .transpose
        .map { |stack| { stack.last => stack.reverse.drop(1).filter { |s| not s.empty? } } }
        .inject(:merge)
end

procedure = input
    .last
    .split("\n")
    .map(&:split)
    .map { |a| [a[1], a[3], a[5]]}

def part_one(stacks, procedure)
    procedure.each do |instruction|
        quantity = instruction[0].to_i
        from = stacks[instruction[1]]
        to = stacks[instruction[2]]
        what = from.pop(quantity).reverse
        to.concat what
    end

    stacks
        .values
        .map { |value| value.last }
        .join
end

def part_two(stacks, procedure)
    procedure.each do |instruction|
        quantity = instruction[0].to_i
        from = stacks[instruction[1]]
        to = stacks[instruction[2]]
        what = from.pop(quantity)
        to.concat what
    end

    stacks
        .values
        .map { |value| value.last }
        .join
end

puts "Part one: #{part_one prepare_stacks(input), procedure }"
puts "Part two: #{part_two prepare_stacks(input), procedure }"