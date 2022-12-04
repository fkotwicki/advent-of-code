assignment_pairs = File.read("input.txt").split("\n").map { |a| a.split(',') }

part_one = assignment_pairs.map { |pair| 
    p1_start, p1_end = pair[0].split("-").map(&:to_i)
    p2_start, p2_end = pair[1].split("-").map(&:to_i)

    p1 = *(p1_start..p1_end)
    p2 = *(p2_start..p2_end)

    ((p1 & p2).size == p1.size || (p2 & p1).size == p2.size) ? 1 : 0
}.sum

part_two = assignment_pairs.map { |pair| 
    p1_start, p1_end = pair[0].split("-").map(&:to_i)
    p2_start, p2_end = pair[1].split("-").map(&:to_i)

    p1 = *(p1_start..p1_end)
    p2 = *(p2_start..p2_end)

    ((p1 & p2).size > 0) ? 1 : 0
}.sum

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"