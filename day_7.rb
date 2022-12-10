class Directory 
  attr_reader :parent

  def initialize(level, name, parent)    
    @level = level
    @name = name 
    @nested_directories = []
    @files = {}
    @parent = parent
  end

  def add_nested(directory)
    @nested_directories << directory
  end

  def add_file(name, size)
    @files[name] = size
  end

  def calculate_total_size
    sum_of_files + sum_of_nested_directories
  end

  def sum_of_files
    @files.values.sum
  end

  def sum_of_nested_directories
    @nested_directories.sum do |directory|
      directory.calculate_total_size
    end
  end
end

def directories
  directories = []
  level = 0
  current_directory = nil
  File.foreach("./puzzle_input/directories.txt") do |line|
    if line[2..3] == "cd" && line[5..6] != ".."
      new_directory = Directory.new(level, line[5..-2], current_directory)
      if current_directory != nil 
        current_directory.add_nested(new_directory)
      end
      directories << new_directory
      current_directory = new_directory
      level = level + 1
    elsif line[0..3] == "$ ls" || line[0..2] == "dir"
      next
    elsif line[2..6] == "cd .."
      current_directory = current_directory.parent
      level = level - 1
    else 
      size, name = line.split(" ")
      current_directory.add_file(name, size.to_i)
    end
  end
  directories
end

def part_one
  sums = directories.map { |directory| directory.calculate_total_size }
  filtered = sums.select { |sum| sum < 100000}
  filtered.sum
end

def part_two
  space_in_use = directories[0].calculate_total_size
  additional_needed = 30000000 - (70000000 - space_in_use)
  options = directories.map { |directory| directory.calculate_total_size }.select { |size| size > additional_needed }
  options.min
end

puts "Part one: #{part_one}"
puts "Part two: #{part_two}"