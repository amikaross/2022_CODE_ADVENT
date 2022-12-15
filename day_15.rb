map_hash = {}
all_beacons = []

File.foreach("./puzzle_input/beacons.txt") do |line|
  sensor, beacon = line.split(": ").map { |str| str.scan(/-?\d+/).map(&:to_i) }
  distance_between = (beacon[0] - sensor[0]).abs + (beacon[1] - sensor[1]).abs 

  next if (sensor[1] + distance_between < 2000000) || (sensor[1] - distance_between > 2000000)

  all_beacons << beacon if beacon[1] == 2000000

  column, row = sensor 

  ((row - distance_between)..row).each_with_index do |current_row, i|
    next if current_row != 2000000
    ((column - i)..(column + i)).each do |j|
      map_hash[current_row] ? map_hash[current_row] << j : map_hash[current_row] = [j]
    end
  end
  ((row + 1)..(row + distance_between)).each_with_index do |current_row, i|
    next if current_row != 2000000
    ((column - (distance_between - (i + 1)))..(column + ((distance_between - (i + 1))))).each do |j|
      map_hash[current_row] ? map_hash[current_row] << j : map_hash[current_row] = [j]
    end
  end
end

nun_beacons_on_row = all_beacons.uniq.count { |beacon| beacon[1] == 2000000 }
count_empties = map_hash[2000000].uniq.count - nun_beacons_on_row

puts "Part one: #{count_empties}"


