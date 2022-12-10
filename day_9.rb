class Rope
  attr_reader :all_tail_positions
  attr_accessor :behind, :head_position

  def initialize(tail=false)
    @head_position = [0, 0]
    @tail_position = [0, 0]
    @all_tail_positions = ["00"]
    @behind = nil
    @tail = tail
  end

  def head_moves(direction)
    a_head_move(direction)
    move_tail
  end

  def move_tail
    if tail_adjacent?
      return 
    elsif needs_to_move_diagonally? 
      a_diagonal_move
    else
      a_regular_tail_move
    end
    add_marker if @tail == true
    if @behind != nil 
      @behind.head_position = @tail_position
      @behind.move_tail
    end
  end

  def add_marker
    marker = @tail_position.join("")
    @all_tail_positions << marker
  end

  def tail_adjacent?
    ((@head_position[0] - 1)..(@head_position[0] + 1)).include?(@tail_position[0]) &&
    ((@head_position[1] - 1)..(@head_position[1] + 1)).include?(@tail_position[1])
  end

  def needs_to_move_diagonally? 
    @head_position[0] != @tail_position[0] && @head_position[1] != @tail_position[1]
  end

  def a_head_move(direction)
    if direction == "R"
      @head_position[1] += 1
    elsif direction == "L"
      @head_position[1] -= 1
    elsif direction == "U"
      @head_position[0] += 1
    else
      @head_position[0] -= 1
    end
  end

  def a_regular_tail_move
    if @head_position[0] < @tail_position[0]
      @tail_position[0] -= 1
    elsif @head_position[0] > @tail_position[0]
      @tail_position[0] += 1
    elsif @head_position[1] < @tail_position[1]
      @tail_position[1] -= 1
    else
      @tail_position[1] += 1
    end
  end

  def a_diagonal_move
    # if the tail is only one square away from being in the same column as the head
    if ((@head_position[1] - 1)..(@head_position[1] + 1)).include?(@tail_position[1])
      @tail_position[1] = @head_position[1]
      if @head_position[0] > @tail_position[0]
        @tail_position[0] += 1
      else
        @tail_position[0] -= 1
      end
    # else if the tail is only one square away from being in the same ROW as the head
    elsif ((@head_position[0] - 1)..(@head_position[0] + 1)).include?(@tail_position[0])
      @tail_position[0] = @head_position[0]
      if @head_position[1] > @tail_position[1]
        @tail_position[1] += 1
      else
        @tail_position[1] -= 1
      end
    # ELSE if it can't get inline at all  
    else
      if @head_position[1] > @tail_position[1]
        @tail_position[1] += 1
      else
        @tail_position[1] -= 1
      end
      if @head_position[0] > @tail_position[0]
        @tail_position[0] += 1
      else
        @tail_position[0] -= 1
      end
    end
  end
end

def part_one
  rope = Rope.new(true)
  File.foreach("./puzzle_input/rope.txt") do |line|
    direction = line.chomp[0]
    num_moves = line.chomp[2..-1].to_i
    num_moves.times do 
      rope.head_moves(direction)
    end
  end
  rope.all_tail_positions.uniq.count
end

def part_two
  start = Rope.new
  one = start.behind = Rope.new
  two = one.behind = Rope.new
  three = two.behind = Rope.new
  four = three.behind = Rope.new
  five = four.behind = Rope.new 
  six = five.behind = Rope.new
  seven = six.behind = Rope.new 
  tail = seven.behind = Rope.new(true) 

  File.foreach("./puzzle_input/rope.txt") do |line|
    direction = line.chomp[0]
    num_moves = line.chomp[2..-1].to_i
    num_moves.times do 
      start.head_moves(direction)
    end
  end
  count = tail.all_tail_positions.uniq.count
end

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"
