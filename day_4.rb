def part_one
  count = 0
  File.foreach("./puzzle_input/ranges.txt") do |line|
    ranges = line.chomp.split(",").map do |range|
      range.split("-").map(&:to_i)
    end
    either_is_contained?(ranges[0], ranges[1]) ? count += 1 : next
  end
  count
end 

def part_two
  count = 0
  File.foreach("./puzzle_input/ranges.txt") do |line|
    ranges = line.chomp.split(",").map do |range|
      range.split("-").map(&:to_i)
    end
    overlap?(ranges[0], ranges[1]) ? count += 1 : next
  end
  count
end 

def either_is_contained?(range_1, range_2)
  (range_1.first >= range_2.first && range_1.last <= range_2.last) ||
    (range_2.first >= range_1.first && range_2.last <= range_1.last)
end

def overlap?(range_1, range_2)
  range_2.first <= range_1.last && range_1.first <= range_2.last
end 

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"