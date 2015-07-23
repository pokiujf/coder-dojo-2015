require '../support/process_file'

ProcessFile.new do |line|
  data, operations = line.strip.split(' : ')
  data = data.split(' ')
  operations = operations.split(', ').map{|operation| operation.split('-').map(&:to_i)}
  # puts "data: #{data}"
  # puts "operations: #{operations}"
  operations.each do |operation|
    first_digit =  data[operation.first]
    last_digit = data[operation.last]
    data[operation.first] = last_digit
    data[operation.last] = first_digit
  end
  puts data.join(' ')
end