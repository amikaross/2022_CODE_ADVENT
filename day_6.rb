def do_the_thing(size)
  file = File.read('./puzzle_input/data_stream.txt')
  count = size
  window = file[0..(size - 1)].chars
  file.chars.each_with_index do |char, i|
    next if i < size
    if window == window.uniq
      return count
    else 
      window.push(char).shift
      count += 1
    end
  end
end

puts "Part one: #{do_the_thing(4)}"
puts "Part two: #{do_the_thing(14)}"