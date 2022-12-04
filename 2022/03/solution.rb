def priority(char)
    return char.ord - 96 if char.downcase == char
    return char.ord - 38 if char.upcase == char
end

rucksacks = File.readlines("input.txt").map(&:strip)

part_one = rucksacks.map { |r| r.chars.each_slice(r.size / 2).to_a }.map{ |c| priority((c[0] & c[1])[0]) }.sum
part_two = rucksacks.each_slice(3).to_a.map { |g| priority((g[0].chars & g[1].chars & g[2].chars)[0]) }.sum

puts "Part one: #{part_one}"
puts "Part one: #{part_two}"