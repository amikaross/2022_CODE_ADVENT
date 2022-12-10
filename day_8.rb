class TreeCounter
  def initialize(filename)
    @filename = filename
    @rows = {}
    @columns = {}
  end

  def build_grid
    row = 0
    file = File.foreach(@filename) do |line|
      line.chomp.chars.each_with_index do |char, i|
        if row == 0
          @columns[i] = [char.to_i]
        else
          @columns[i] << char.to_i
        end
      end
      @rows[row] = line.chomp.chars.map(&:to_i)
      row += 1
    end
  end

  def height
    @rows.count
  end

  def width
    @columns.count
  end

  def total_visible
    count_inner_visible + count_outer_ring
  end

  def count_outer_ring
    (height * 2) + ((width - 2) * 2)
  end

  def count_inner_visible
    count = 0
    build_grid
    (1..(height - 2)).each do |i|
      (1..(width - 2)).each do |j|
        count += 1 if is_it_visible?(@columns[j], @rows[i], i, j)
      end
    end
    count
  end

  def is_it_visible?(column, row, column_i, row_i)
    if check_left_or_top(column, column_i) || check_left_or_top(row, row_i)
      return true
    elsif check_right_or_bottom(column, column_i) || check_right_or_bottom(row, row_i)
      return true
    else
      return false
    end
  end
  
  def check_left_or_top(array, index)
    (0..(index-1)).each do |i|
      if array[i] >= array[index]
        return false
      else 
        next
      end
    end
    true
  end
  
  def check_right_or_bottom(array, index)
    ((index + 1)..(array.length - 1)).each do |i|
      if array[i] >= array[index]
        return false
      else
        next
      end
    end
    return true
  end

  def highest_scenic_score
    build_grid
    scores = []
    (0..(height - 1)).each do |i|
      (0..(width - 1)).each do |j|
        scores << scenic_score(@columns[j], @rows[i], i, j)
      end
    end
    scores.max
  end

  def scenic_score(column, row, column_i, row_i)
    left_or_top_score(column, column_i) * left_or_top_score(row, row_i) *
    right_or_bottom_score(column, column_i) * right_or_bottom_score(row, row_i)
  end

  def left_or_top_score(array, index)
    return 0 if index == 0
    array_section = array[0..(index - 1)].reverse
    tree_house_height = array[index]
    score = 0
    (0..(array_section.length - 1)).each do |i|
      if array_section[i] >= tree_house_height
        score += 1
        return score
      else
        score += 1
      end
    end
    score
  end

  def right_or_bottom_score(array, index)
    return 0 if index == array.length - 1
    array_section = array[(index + 1)..(array.length - 1)]
    tree_house_height = array[index]
    score = 0
    (0..(array_section.length - 1)).each do |i|
      if array_section[i] >= tree_house_height
        score += 1
        return score
      else
        score += 1
      end
    end
    score
  end

end

def part_one
  tc = TreeCounter.new("./puzzle_input/trees.txt")
  tc.total_visible
end

def part_two
  tc = TreeCounter.new("./puzzle_input/trees.txt")
  tc.highest_scenic_score
end

puts "Part One: #{part_one}"
puts "Part Two: #{part_two}"