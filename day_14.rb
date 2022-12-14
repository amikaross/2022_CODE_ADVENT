class SandCounter
  def initialize(file)
    @file = file
    @cave = CaveHash.new
  end

  def build_structures
    File.foreach(@file) do |line|
      structure = line.chomp.split(" -> ").map { |coord| coord.split(",").map(&:to_i) }
      @cave.add_structure_to_map(structure)
    end
    @cave.map.each { |key, array| @cave.map[key] = array.uniq }
    @cave.find_abyssal_ceiling
  end

  def part_one
    build_structures
    @cave.drop_sand("part one")
  end

  def part_two
    build_structures
    @cave.add_true_floor
    count = @cave.drop_sand("part two") + 1
  end
end

class CaveHash
  attr_reader :map, :abyssal_ceiling

  def initialize
    @map = {}
    @abyssal_ceiling = nil
    @true_floor = nil
  end

  def drop_sand(style)
    count = 0
    loop do
      return count if sand_comes_to_rest(style) == false
      column, row = sand_comes_to_rest(style)
      @map[row] ? @map[row] << column : @map[row] = [column]
      count += 1
    end
  end

  def sand_comes_to_rest(style)
    current_row = 0
    current_column = 500
    loop do 
      if can_fall_down?([current_column, current_row])
        current_row += 1 
      elsif can_fall_left?([current_column, current_row])
        current_row += 1
        current_column -= 1
      elsif can_fall_right?([current_column, current_row])
        current_row += 1
        current_column += 1
      else
        return false if current_row == 0 && current_column == 500
        return [current_column, current_row]
      end
      return false if current_row >= @abyssal_ceiling && style == "part one"
    end
  end

  def can_fall_down?(position)
    current_column, current_row = position
    @map[current_row + 1] ? !@map[current_row + 1].include?(current_column) : true
  end

  def can_fall_left?(position)
    current_column, current_row = position
    @map[current_row + 1] ? !@map[current_row + 1].include?(current_column - 1) : true
  end

  def can_fall_right?(position)
    current_column, current_row = position
    @map[current_row + 1] ? !@map[current_row + 1].include?(current_column + 1) : true
  end

  def add_structure_to_map(coordinates_array)
    (0..(coordinates_array.length - 1)).each do |i|
      current_row = coordinates_array[i][1]
      current_column = coordinates_array[i][0]
      previous_row = coordinates_array[i - 1][1]
      previous_column = coordinates_array[i - 1][0]
      if i == 0
        @map[current_row] ? @map[current_row] << current_column : @map[current_row] = [current_column]
      else
        if previous_row != current_row
          if previous_row < current_row
            ((previous_row + 1)..current_row).each do |row_num|
              @map[row_num] ? @map[row_num] << current_column : @map[row_num] = [current_column]
            end
          else
            (current_row..(previous_row - 1)).each do |row_num|
              @map[row_num] ? @map[row_num] << current_column : @map[row_num] = [current_column]
            end
          end
        elsif previous_column != current_column
          if previous_column < current_column
            ((previous_column + 1)..current_column).each { |column_num| @map[current_row] << column_num }
          else
            (current_column..(previous_column - 1)).each { |column_num| @map[current_row] << column_num }
          end
        end
      end
    end
  end

  def find_abyssal_ceiling
    @abyssal_ceiling = @map.keys.max
  end

  def add_true_floor
    columns = @map.values.map { |value| value.min }
    min = columns.min
    max = columns.max
    @map[@abyssal_ceiling + 2] = ((min-200)..(max + 200)).to_a
  end
end

scone = SandCounter.new("./puzzle_input/sand.txt")
sctwo = SandCounter.new("./puzzle_input/sand.txt")

puts "Part one: #{scone.part_one}"
puts "Part two: #{sctwo.part_two}"
