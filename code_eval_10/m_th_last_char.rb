require '../support/process_file.rb'

ProcessFile.new do |line|
  elements = line.strip.split(' ')
  num = elements.pop.to_i
  puts elements[-num]
end