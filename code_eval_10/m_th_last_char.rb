File.open(ARGV[0], "r").each_line do |line|
  elements = line.strip.split(' ')
  puts elements[-(elements.last.to_i+1)]
end