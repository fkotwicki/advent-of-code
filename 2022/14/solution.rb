class Coord
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def to_s
        "x:#{@x} y:#{@y}"
    end

    def inspect
        to_s
    end
end
traces = File.readlines("test_input.txt")
        .map(&:strip)
        .map {|trace|
                trace.split("->").map { |coord| 
                x, y = coord.split(",")
                Coord.new x, y
            }   
        }
    

pp traces[0]
