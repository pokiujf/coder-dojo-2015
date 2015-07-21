File.open(ARGV[0], "r").each_line do |line| 
  sentence, chars = line.split(', ')
  puts sentence.gsub(Regexp.new(chars.split('').join('|')), '')
end
