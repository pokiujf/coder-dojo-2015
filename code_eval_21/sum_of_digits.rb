filename = ARGV[0] || 'digits.txt'

File.open(filename, "r").each_line do |line| 
  puts line.split('').map(&:to_i).reduce(&:+)
end