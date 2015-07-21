require '../support/process_file'

ProcessFile.new do |line|
  sentence, chars = line.split(', ')
  puts sentence.gsub(Regexp.new(chars.split('').join('|')), '')
end