class BeaconFinder 
  def initialize(file)
    @file = file
    @signals = {}
  end

  def calculate_frequency(limit)
    x, y = check_grid(limit)
    (x * 4000000) + y
  end

  def deploy_sensors
    File.foreach(@file) do |line|
      sensor, beacon = line.split(": ").map { |str| str.scan(/-?\d+/).map(&:to_i) }
      distance_between = (beacon[0] - sensor[0]).abs + (beacon[1] - sensor[1]).abs 

      @signals[sensor] = distance_between
    end 
  end

  def can_be_seen?(coordinates)
    @signals.each do |sensor, distance|
      if visible_to_sensor(coordinates, sensor, distance)
        return true
      end
    end
    false
  end

  def visible_to_sensor(coordinates, sensor, distance)
    sx, sy = sensor
    cx, cy = coordinates 
    ((cx - sx).abs + (cy - sy).abs) <= distance
  end

  def check_grid(limit)
    deploy_sensors
    @signals.each do |sensor, distance|
      perimeter(sensor, distance).each do |coords|
        next if coords[0] < 0 || coords[0] > limit || coords[1] < 0 || coords[1] > limit
        return coords if !can_be_seen?(coords)
      end
    end
  end

  def perimeter(sensor, distance)
    perimeter = []
    d = distance + 1
    sx, sy = sensor 

    ((sx - d)..sx).each_with_index do |x, index| 
      perimeter << [x, sy - index]
      perimeter << [x, sy + index]
    end

    (sx..(sx + d)).each_with_index do |x, index| 
      perimeter << [x, (sy - d) + index ]
      perimeter << [x, (sy + d) - index ]
    end

    perimeter.uniq
  end
end

bf = BeaconFinder.new("./puzzle_input/beacons.txt")
part_two = bf.calculate_frequency(4000000)

puts "Part two: #{part_two}"
