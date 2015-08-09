filename = ARGV[0] || 'data.txt'

File.open(filename, "r").each_line do |line|
  puts line.split(' | ').map{|str| str.split.map(&:to_i)}.transpose.map(&:max).join(' ')
end