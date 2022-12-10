LOOKUP = Hash[(("a".."z").to_a + ("A".."Z").to_a).zip((1..52).to_a)]

def part_1
  rucksacks = File.readlines("./puzzle_input/rucksacks.txt")
  array = rucksacks.map { |sack| sack.chars.each_slice(sack.length / 2).to_a }
  array.map { |sack| LOOKUP[(sack[0] & sack[1]).first] }
end 

def part_2
  groups = File.readlines("./puzzle_input/rucksacks.txt").each_slice(3).to_a
  array = groups.map { |group| group.map { |elf| elf.chars } }
  array.map { |sack| LOOKUP[(sack[0] & sack[1] & sack[2]).first] }
end

sum_1 = part_1.sum
sum_2 = part_2.sum

puts "Part one: #{sum_1}"
puts "Part two: #{sum_2}"
