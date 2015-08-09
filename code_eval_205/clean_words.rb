filename = ARGV[0] || 'data.txt'

File.open(filename, "r").each_line do |line|
  puts line.scan(/([a-z]+)/i).join(' ').downcase
end