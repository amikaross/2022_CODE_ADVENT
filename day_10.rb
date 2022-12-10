
class Program 
  attr_reader :rendering 

  def initialize(file)
    @file = file
    @at_20 = 0
    @at_60 = 0
    @at_100 = 0
    @at_140 = 0
    @at_180 = 0
    @at_220 = 0
    @row = 0
    @rendering = ""
  end
  
  def check_cycle_num(x, cycle)
    if cycle == 20
      @at_20 = x
    elsif cycle == 60 
      @at_60 = x
    elsif cycle == 100
      @at_100 = x
    elsif cycle == 140 
      @at_140 = x
    elsif cycle == 180
      @at_180 = x
    elsif cycle == 220
      @at_220 = x
    end
  end

  def run_program
    cycle = 1 
    x = 1
    draw_pixel(cycle, x)
    File.foreach(@file) do |line|
      if line.chomp[0..3] == "addx"
        cycle += 1
        check_cycle_num(x, cycle)
        draw_pixel(cycle, x)
        cycle += 1
        x += line.chomp[5..-1].to_i
        check_cycle_num(x, cycle)
        draw_pixel(cycle, x)
      elsif line.chomp[0..3] == "noop"
        cycle += 1
        check_cycle_num(x, cycle)
        draw_pixel(cycle, x)
      end
    end
  end

  def draw_pixel(cycle, x)
    position = cycle - (@row * 40) - 1
    if ((x - 1)..(x + 1)).include?(position)
      @rendering << "#"
    else 
      @rendering << "."
    end
    if cycle % 40 == 0 
      @rendering << "\n" 
      @row += 1
    end
  end

  def multiply_and_sum_strengths
    (@at_20 * 20) +
    (@at_60 * 60) +
    (@at_100 * 100) +
    (@at_140 * 140) +
    (@at_180 * 180) +
    (@at_220 * 220)
  end
end

def part_one
  p = Program.new("./puzzle_input/signal.txt")
  p.run_program
  p.multiply_and_sum_strengths
end

def part_two
  p = Program.new("./puzzle_input/signal.txt")
  p.run_program 
  p.rendering
end

puts "Part one: #{part_one}"
puts "Part two:\n#{part_two}"