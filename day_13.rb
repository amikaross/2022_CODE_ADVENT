require "json"

class Comparer
  def initialize(file)
    @file = file
  end

  def part_one
    indices = []
    file = File.read(@file).split("\n\n")
    file = file.map { |comparison| comparison.split("\n") }
    file.each_with_index do |comparison, i|
      left = JSON.parse(comparison[0].gsub(/([0-9+].to_i)/, '"\1"'))
      right = JSON.parse(comparison[1].gsub(/([0-9+].to_i)/, '"\1"'))
    
      compare(left, right) ? indices << i + 1 : next
    end
    indices.sum
  end

  def part_two
    file = File.read(@file).split("\n").select { |line| line != "" }
    parsed = file.map { |line| JSON.parse(line.gsub(/([0-9+].to_i)/, '"\1"')) }
    with_packets = parsed.push([[2]], [[6]])
    as_hashes = with_packets.map { |line| {key: line} }
    ordered = merge_sort(as_hashes)
    signal_1 = ordered.find_index({ key: [[2]]}) + 1
    signal_2 = ordered.find_index({ key: [[6]]}) + 1
    signal_1 * signal_2
  end

  def merge_sort(unsorted)
    if unsorted.length <= 1
      return unsorted
    else
      midpoint = (unsorted.length / 2)
      first = merge_sort(unsorted.take(midpoint))
      second = merge_sort(unsorted.drop(midpoint))
      combine(first, second)
    end
  end

  def combine(first, second)
    sorted = []
    until first.empty? || second.empty? do 
      if compare(first[0][:key], second[0][:key])
        sorted.push(first.shift)
      else
        sorted.push(second.shift)
      end
    end
    sorted.concat(first).concat(second)
  end

  def compare(left, right)
    max = [left.length, right.length].max
    (0..(max - 1)).each do |i|
      return true if left[i] == nil && right[i] != nil
      return false if left[i] != nil && right[i] == nil

      if left[i].class == Integer && right[i].class == Integer
        return true if left[i] < right[i]
        return false if left[i] > right[i]
      elsif left[i].class == Integer && right[i].class == Array 
        inside = compare([left[i]], right[i])
        return inside if inside != "wash"
      elsif left[i].class == Array && right[i].class == Integer
        inside = compare(left[i], [right[i]])
        return inside if inside != "wash"
      elsif left[i].class == Array && right[i].class == Array 
        inside = compare(left[i], right[i])
        return inside if inside != "wash"
      end 
    end
    "wash"
  end
end

c = Comparer.new("./puzzle_input/very_small.txt")

puts "Part one: #{c.part_one}"
puts "Part two: #{c.part_two}"