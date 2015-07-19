file = File.open(ARGV[0], "r")
number_of_lines = file.readline.to_i
puts file.read.split("\n").sort_by!{|line| -line.size }.shift(number_of_lines)

