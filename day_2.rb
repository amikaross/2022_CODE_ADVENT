def you_win(letter)
  if letter == "A"
    "B"
  elsif letter == "B"
    "C"
  else
    "A"
  end
end

def you_lose(letter)
  if letter == "A"
    "C"
  elsif letter == "B"
    "A"
  else 
    "B"
  end
end

def to_other(letter)
  if letter == "X"
    "A"
  elsif letter == "Y"
    "B"
  else
    "C"
  end
end

def find_other(game)
  if game[1]== "X"
    you_lose(game[0])
  elsif game[1] == "Y"
    game[0]
  else 
    you_win(game[0])
  end
end

def left_beats_right(round)
  (round[0] == "A" && round[1] == "C") || (round[0] == "B" && round[1] == "A") || (round[0] == "C" && round[1] == "B")
end

def to_num(letter)
  if letter == "A"
    1
  elsif letter == "B"
    2
  else 
    3
  end
end

def read_file
  file = File.read('./puzzle_input/strategy_guide.txt')
  array = file.split("\n").map { |game| game.split(" ") }
end

def part_one
  read_file.map do |game|
    [game[0], to_other(game[1])]
  end
end

def part_two 
  read_file.map do |game|
    [game[0], find_other(game)]
  end
end

def total_score(version)
  your_score = 0
  version.each do |round|
    if round[0] == round[1]
      your_score += to_num(round[1]) + 3
    elsif left_beats_right(round)
      your_score += to_num(round[1])
    else 
      your_score += to_num(round[1]) + 6
    end
  end
  your_score
end

puts "Part one: #{total_score(part_one)}"
puts "Part two: #{total_score(part_two)}"