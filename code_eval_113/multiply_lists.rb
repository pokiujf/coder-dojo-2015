require '../support/process_file'

ProcessFile.new do |list|
  list1, list2 = list.strip.split(' | ')
  list1 = list1.split.map(&:to_i)
  list2 = list2.split.map(&:to_i)
  combined = []
  list1.each_with_index do |val, index|
    combined[index] = val * list2[index]
  end
  puts combined.join(' ')
end