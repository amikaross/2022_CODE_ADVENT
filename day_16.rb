class Valve
  attr_accessor :name, :connected_to, :observed, :flow_rate, :valve_open, :time_when_opened, :all_tunnels_explored

  def initialize(name, flow_rate, connected_to)
    @name = name
    @observed = false
    @flow_rate = flow_rate
    @connected_to = connected_to
    @valve_open = false
    @time_when_opened = nil
  end

  def open_valve(time)
    @valve_open = true 
    @time_when_opened = time
  end
end

class PressureReleaser 
  def initialize(file)
    @file = file
    @valves = {}
    @ordered_by_priority = []
  end
  
  def scan_valves
    File.foreach(@file) do |line|
      name = line[6..7]
      flow_rate = line.delete("^0-9").to_i
      str = line.split("to valve")[1].chomp
      connected_to = if str[0] == "s" then str[2..-1].split(", ") else str[1..-1].split(", ") end
      @valves[name] = Valve.new(name, flow_rate, connected_to)
      @ordered_by_priority << @valves[name]
    end
    @ordered_by_priority.sort_by!(&:flow_rate).reverse!
  end

  def traverse
    scan_valves
    current_position = @valves["AA"]
    destination = set_destination(current_position)
    (0..30).each do |minute|
      current_position.observed = true 
      if !current_position.valve_open && current_position == destination 
        current_position.open_valve(minute + 1)
        destination = nil
        @ordered_by_priority.delete(current_position)
      else
        destination = set_destination(current_position) if destination.nil?
        current_position = move_toward_destination(current_position, destination)
      end
    end
  end

  def set_destination(current_position)

  end

  def distance_to_highest_priority(current_position)
    distance = 1
    highest = @ordered_by_priority[0]
    connections = @valves.select { |valve| valve.connected_to.include?(highest) }
    if connections.include?(current_position.name)
      return distance, highest 
    else 
      loop do 
        distance += 1
  ###### YOU ARE HERE - AR 12/16 4:30p ######
      end
    end
  end

  # def go_down_tunnel(current_position)
  #   current_position.connected_to.each do |option|
  #     return @valves[option] if !@valves[option].observed
  #   end
  #   current_position.all_tunnels_explored = true 
  #   current_position.connected_to.each do |option|
  #     return @valves[option] if !all_tunnels_explored?(@valves[option])
  #   end
  #   @valves[current_position.connected_to.first]
  # end

  # def all_tunnels_explored?(valve)
  #   valve.connected_to.each { |name| return false if !@valves[name].observed }
  #   true
  # end

  def total_pressure_released 
    traverse
    info = @valves.map { |_, valve| [valve.flow_rate, valve.time_when_opened] }
    open_valves = info.select { |nums| !nums[1].nil? }
    sum = open_valves.sum { |nums| (30 - nums[1]) * nums[0] }
  end
end

pr = PressureReleaser.new("./puzzle_input/valves.txt")

puts "Part one: #{pr.total_pressure_released}"