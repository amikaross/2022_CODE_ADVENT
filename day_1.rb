file = File.read('./puzzle_input/calories.txt')
array = file.split("\n\n").map { |elf| elf.split("\n").sum { |item| item.to_i }}

max = array.max
sum_of_top_three = array.sort[-3..-1].sum

puts "Part 1: #{max}"
puts "Part 2: #{sum_of_top_three}"
