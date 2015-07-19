require '../support/process_file'

ProcessFile.new do |line| 
  puts line.strip.split(',').uniq.join(',') unless line.strip.empty?
end