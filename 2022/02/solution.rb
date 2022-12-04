rounds = File.readlines("input.txt")
Shapes = { "A" => :rock, "X" => :rock, "B" => :paper, "Y"  =>:paper, "C" => :scissors, "Z" => :scissors}
Defeats = { :rock => :scissors, :paper => :rock, :scissors => :paper}
Points = { :rock => 1, :paper => 2, :scissors => 3}

def score(opp, me) 
    if opp == me
        3 + Points[me]
    else
        if Defeats[opp] == me
            0 + Points[me]
        else
            6 + Points[me]
        end
    end
end

def guess_shape(opp, me) 
    return Defeats.key(opp) if me == :scissors
    return Defeats[opp] if me == :rock
    return opp
end

def part_one(round)
    opp, me = round.split.map { |symbol| Shapes[symbol.strip] }
    score opp, me
end

def part_two(round)
    opp, me = round.split.map { |symbol| Shapes[symbol.strip] }
    me = guess_shape opp, me
    score opp, me
end

puts "Part one: #{rounds.map { |round| part_one round }.sum}"
puts "Part two: #{rounds.map { |round| part_two round }.sum}"