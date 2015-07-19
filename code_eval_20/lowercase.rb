require '../support/process_file'
ProcessFile.new do |line|
  puts line.downcase
end