require '../support/process_file'
filename = ARGV[0] || 'arrays.txt'

class RepetitionFinder
  def initialize(sequence)
    @sequence = sequence
  end
  
  def duplicate
    @sequence.sort.each_with_index do |v, i|
      return v if v != i
    end
  end
end

ProcessFile.new(filename) do |line|
  line = line.split(';').last.split(',').map(&:to_i)
  puts RepetitionFinder.new(line).duplicate
end