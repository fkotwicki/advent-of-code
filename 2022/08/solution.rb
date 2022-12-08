def is_visible?(row, tree)
    row.detect{ |t| t >= tree } == nil
end

def part_one(trees_map)
    visible_trees = 0
    for row_index in 0..trees_map.size - 1 do
        row = trees_map[row_index]
        for tree_index in 0..row.size - 1 do
            col = trees_map.map { |row| row[tree_index] }
            tree = row[tree_index]
            visible = (is_visible? row[tree_index + 1..-1], tree) || # right
                      (is_visible? row[0...tree_index], tree) ||     # left
                      (is_visible? col[0...row_index], tree) ||      # top
                      (is_visible? col[row_index + 1..-1], tree)     # bottom
            visible_trees += visible ? 1 : 0
        end
    end
    visible_trees
end

def view_distance(row, tree)
    blocked = false
    row.take_while { |t|
        can_view = !blocked
        blocked = t >= tree
        can_view
    }.size
end

def part_two(trees_map)
    scores = []
    for row_index in 0..trees_map.size - 1 do
        row = trees_map[row_index]
        for tree_index in 0..row.size - 1 do
            col = trees_map.map { |row| row[tree_index] }
            tree = row[tree_index]
            scores << (view_distance row[tree_index + 1..-1], tree) * 
                      (view_distance row[0...tree_index].reverse, tree) * 
                      (view_distance col[0...row_index].reverse, tree) * 
                      (view_distance col[row_index + 1..-1], tree) 
        end
    end
    scores.max
end

trees_map = File.readlines("input.txt").map(&:strip).map { |row| row.chars.map { |c| c.to_i } }

puts "Part one: #{part_one trees_map}"
puts "Part two: #{part_two trees_map}"