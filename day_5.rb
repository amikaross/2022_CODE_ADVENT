class CrateMover
  def initialize(filename)
    @file = filename
    @stacks = {}
    @moves = build_moves
  end

  def build_starting_stacks
    first_line = true
    File.foreach(@file) do |line|
      char_arr = line.chomp.chars.each_slice(4).to_a
      if line[1] == "1"
        return
      elsif first_line == true
        initialize_stacks(char_arr)
        first_line = false
      else
        fill_stacks(char_arr)
      end
    end
  end
  
  def initialize_stacks(char_arr)
    count = 1
    char_arr.each do |char|
      stack = Stack.new(count)
      count += 1
      if char[1] != " "
        stack.crates.unshift(char[1])
      end
      @stacks[stack.id] = stack
    end
  end
  
  def fill_stacks(char_arr)
    count = 1
    char_arr.each do |char| 
      @stacks[count].crates.unshift(char[1]) if char[1] != " "
      count += 1
    end
  end
  
  def build_moves
    moves =[]
    File.foreach(@file) do |line|
      if line[0] != "m"
        next
      else
        moves << line.tr!("frmovet", "").split(" ")  
      end
    end
    moves
  end
  
  def execute_move(directions, style)
    id_1 = directions[1].to_i
    id_2 = directions[2].to_i
    if style == "part_one"
      directions[0].to_i.times do 
        @stacks[id_1].move_crate_to(@stacks[id_2])
      end
    else
      @stacks[id_1].move_multiple_crates_to(@stacks[id_2], directions[0].to_i)
    end
  end

  def perform_moves(style)
    build_starting_stacks
    @moves.each do |directions|
      execute_move(directions, style)
    end
  end
  
  def top_crates
    @stacks.values.each_with_object("") do |stack, str|
      str << stack.crates.last
    end
  end
end

class Stack
  attr_accessor :crates, :id

  def initialize(id)
    @id = id
    @crates = []
  end

  def move_crate_to(other_stack)
    crate = @crates.pop
    other_stack.crates << crate
  end

  def move_multiple_crates_to(other_stack, num_crates)
    crates = @crates.slice!(-num_crates..-1)
    other_stack.crates.concat(crates)
  end
end

def part_one
  sm = CrateMover.new("./puzzle_input/crates.txt")
  sm.perform_moves("part_one")
  sm.top_crates
end

def part_two
  sm = CrateMover.new("./puzzle_input/crates.txt")
  sm.perform_moves("part_two")
  sm.top_crates
end

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"
