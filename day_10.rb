
class Program 
  attr_reader :rendering 

  def initialize(file)
    @file = file
    @signals = []
    @row = 0
    @rendering = ""
  end
  
  def check_cycle_num(x, cycle)
    important = [20, 60, 100, 140, 180, 220]
    @signals << x if important.include?(cycle)
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
    important = [20, 60, 100, 140, 180, 220]
    @signals.zip(important).map { |signal| signal[0] * signal[1] }.sum
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