calories = File.readlines("input.txt")
elves = calories.inject([[]]) { |acc, item|
    if item.strip.empty?
        acc << []; 
    else 
        acc.last << item.to_i;
    end
    acc
}.map(&:sum)

part_one = elves.max
part_two = elves.sort.reverse.take(3).sum

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"