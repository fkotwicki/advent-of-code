def detect(input, num_of_chars)
    chars = input.chars
    position = 0
    chars.each_with_index do | _, i |
        if chars[i...i + num_of_chars].uniq.size == num_of_chars
            position = i + num_of_chars
            break
        end 
    end
    position
end

input = File.read("input.txt")

puts "Part one: #{detect(input, 4)}"
puts "Part two: #{detect(input, 14)}"