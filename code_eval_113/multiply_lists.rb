require '../support/process_file'

ProcessFile.new do |lists|
  list1, list2 = lists.strip.split(' | ').map{|list| list.split.map(&:to_i)}
  puts list1.zip(list2).map{|sub_arr| sub_arr.reduce(:*)}.flatten.join(' ')
end