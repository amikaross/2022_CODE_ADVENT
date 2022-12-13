class PathFinder
  attr_reader :starting, :ending

  def initialize(file)
    @file = file
    @starting = nil
    @ending = nil
    @grid = []
  end

  def initialize_grid
    File.foreach(@file) { |line| @grid << line.chomp.chars }
  end

  def find_start_and_end
    initialize_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        if @grid[i][j] == "S"
          @starting = [i, j]
          @grid[i][j] = "a"
        elsif @grid[i][j] == "E" 
          @ending = [i, j]
          @grid[i][j] = "z"
        end
      end
    end
  end

  def find_path(starting, style, backwards)
    # put every viable move into an array and call it "at_now" (at start this is only one coordinate - start)
    at_now = [starting]
    possibilities = []
    steps = 0 
    
    loop do
      # iterate through the at_now array and put every possible move into another array called possibilites
      at_now.each do |coordinate|
        next if @grid[coordinate[0]][coordinate[1]] == "SEEN"
        neighbors = all_adjacent_to(coordinate)
        neighbors.each do |neighbor|
          if step_can_be_taken?(neighbor, coordinate, backwards)
            possibilities << neighbor 
            # When a neighbor is the end you're looking for, return the number of steps counted so far + 1
            return steps + 1 if escape(style, neighbor)
          end
        end
        # don't let yourself go backwards
        @grid[coordinate[0]][coordinate[1]] = "SEEN"
      end
      # after that iteration is complete, the possibilities array becomes your "at_now", possibilities empties and the process repeats. 
      # each time you move to a new "possibilities" array you "take a step". It spreads out like a ink blot, covering every possible move. When the ending is within the next possible move, the steps taken are returned.
      at_now = possibilities
      possibilities = []
      steps += 1
    end
    steps
  end

  def escape(style, neighbor)
    style == "part_one" ? neighbor == @ending : @grid[neighbor[0]][neighbor[1]] == "a"
  end

  def step_can_be_taken?(potential_step, current_position, backwards)
    inside_grid?(potential_step) &&
      @grid[potential_step[0]][potential_step[1]] != "SEEN" &&
        one_away?(potential_step, current_position, backwards)
  end

  def one_away?(potential_step, current_position, backwards)
    if backwards == false
      (@grid[potential_step[0]][potential_step[1]].ord - @grid[current_position[0]][current_position[1]].ord) <= 1
    else
      (@grid[current_position[0]][current_position[1]].ord - @grid[potential_step[0]][potential_step[1]].ord) <= 1
    end
  end

  def inside_grid?(coordinate)
    coordinate[0] >= 0 && coordinate[0] < (@grid.length) &&
      coordinate[1] >= 0 && coordinate[1] < @grid[0].length
  end

  def all_adjacent_to(coordinate)
    i, j = coordinate
    [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]]
  end
end

def part_one
  pf = PathFinder.new("./puzzle_input/elevation.txt")
  pf.find_start_and_end
  pf.find_path(pf.starting, "part_one", false)
end

def part_two
  pf = PathFinder.new("./puzzle_input/elevation.txt")
  pf.find_start_and_end
  pf.find_path(pf.ending, "part_two", true)
end

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"
