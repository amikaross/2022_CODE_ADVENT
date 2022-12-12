class Monkey 
  attr_accessor :tests, :operation, :items_holding, :name, :items_inspected_count

  def initialize(name, operation, tests)
    @name = name 
    @items_holding = nil
    @items_inspected_count = 0
    @tests = tests
    @operation = operation
  end

  def inspect(item, decreaser)
    item.worry_level = (perform_operation(item)) % decreaser
    if perform_test_on(item) == true
      @tests[1]
    else
      @tests[2]
    end
  end

  def perform_operation(item)
    op = @operation.map { |char| char == "old" ? char = item.worry_level : char }
    op[0].to_i.method(op[1]).(op[2].to_i)
  end

  def perform_test_on(item)
    item.worry_level % @tests[0].to_i == 0 ? true : false
  end
end

class Item 
  attr_accessor :worry_level

  def initialize(id, starting_worry_level)
    @id = id
    @worry_level = starting_worry_level
  end
end

class ShenaniganCounter
  attr_reader :monkeys

  def initialize(file)
    @file = file
    @monkeys = {}
    @decreaser = nil
  end

  def initialize_monkeys
    item_ids = (1..100).to_a
    file = File.read(@file).split("\n\n")
    file.each do |monkey|
      monkey_info = monkey.split("\n")
      name = monkey_info[0][0..-2].downcase
      items = monkey_info[1].split(": ")[1].split(", ").map(&:to_i)
      operation = monkey_info[2].split("= ")[1].split(" ")
      tests = [monkey_info[3].split(" ").last, monkey_info[4][-8..-1], monkey_info[5][-8..-1]]

      @monkeys[name] = Monkey.new(name, operation, tests)
      @monkeys[name].items_holding = items.map { |item| Item.new(item_ids.shift, item) }
      @decreaser = @monkeys.values.map { |monkey| monkey.tests[0].to_i }.inject(:*)
    end
  end  

  def run_twenty_rounds
    initialize_monkeys
    10000.times do 
      @monkeys.each do |_, monkey|
        if monkey.items_holding != []
          monkey.items_holding.each do |item|
            name = monkey.inspect(item, @decreaser)
            give_item_to(monkey, name, item)
          end
          monkey.items_holding = []
        else
          next
        end
      end
    end
  end

  def give_item_to(monkey, other_monkey_name, item)
    @monkeys[other_monkey_name].items_holding << item
    monkey.items_inspected_count += 1
  end
end

s = ShenaniganCounter.new("./puzzle_input/monkeys.txt")
s.run_twenty_rounds
holdings = s.monkeys.values.map { |monkey| monkey.items_inspected_count }.sort
monkey_business = holdings[-1] * holdings[-2]
require 'pry'; binding.pry

