require '../support/process_file'
filename = ARGV[0] || 'jolly.txt'

class Jolly
  def initialize(sequence)
    @sequence = sequence[1..-1]
  end
  
  def to_s
    jump? ? 'Jolly' : 'Not jolly'
  end
  
  private
  
  def jump?
    return true if @sequence.length == 1
    differencies = []
    @sequence.each_with_index do |val, index|
      break if @sequence[index + 1].nil?
      differencies << [val, @sequence[index + 1]]
    end
    differencies = differencies.map{|sub_arr| sub_arr.reduce(&:-).abs}.uniq.sort
    (1..@sequence.length-1).to_a == differencies
  end
end

ProcessFile.new(filename) do |sequence|
  puts Jolly.new(sequence.strip.split(' ').map(&:to_i))
end