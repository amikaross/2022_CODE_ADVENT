class Monkey 
  attr_accessor :monkey_1, :monkey_2, :operation, :total, :name, :touched
  def initialize(name)
    @name = name 
    @monkey_1 = nil
    @monkey_2 = nil
    @operation = nil
    @total = nil
    @touched = nil
  end

  def perform_operation
    @touched = true if self.name == "humn" 
    if @total.nil?
      first_monkey_total = @monkey_1.perform_operation
      second_monkey_total = @monkey_2.perform_operation
      first_monkey_total.method(@operation).(second_monkey_total)
    else 
      @total
    end
  end
end

class MonkeyMath
  def initialize(file)
    @file = file
    @monkeys = {}
  end

  def load_monkeys
    File.foreach(@file) do |line|
      name, operation = line.chomp.split(": ")

      @monkeys[name] = Monkey.new(name) if !@monkeys[name]
      monkey = @monkeys[name]
      if operation.length < 7
        @monkeys[name].total = operation.to_i
      else
        monkey_1, operation, monkey_2 = operation.split(" ")
        @monkeys[monkey_1] = Monkey.new(monkey_1) if !@monkeys[monkey_1]
        @monkeys[monkey_2] = Monkey.new(monkey_2) if !@monkeys[monkey_2]
        monkey.monkey_1 = @monkeys[monkey_1]
        monkey.monkey_2 = @monkeys[monkey_2]
        monkey.operation = operation 
      end
    end
  end

  def part_one
    load_monkeys
    root = @monkeys["root"]
    root.perform_operation
  end

  def part_two
    thing = find_humn
    require 'pry'; binding.pry
  end

  def find_humn
    load_monkeys
    left = @monkeys["root"].monkey_1
    right = @monkeys["root"].monkey_2
    unchanging, variable_process = check_which_monkey(left, right)
    @monkeys["humn"].touched = nil
### YOU ARE HERE
    loop do
      left, right = [variable_process.monkey_1, variable_process.monkey_2]
      unchanging, variable_process = check_which_monkey(left, right)
      @monkeys["humn"].touched = nil
      return [unchanging, variable_process] if variable_process.name == "humn"
    end
  end

  def check_which_monkey(left, right)
    total = left.perform_operation 
    @monkeys["humn"].touched == true ? [right.perform_operation, left] : [total, right]
  end
end

mm = MonkeyMath.new("./puzzle_input/small.txt")

puts "Part one: #{mm.part_two}"