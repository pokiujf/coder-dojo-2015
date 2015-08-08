require '../support/process_file'
filename = ARGV[0] || 'sequences.txt'

class LoopDetecter
  
  def initialize(sequence)
    @sequence = sequence
  end
  
  def to_s
    detect.join(' ')
  end
  
  private
  
  def detect
    sequence_length = @sequence.length
    max_length = 50 < sequence_length / 2 ? 50 : sequence_length / 2
    loop_lengths = (1..max_length)
    loop_lengths.each do |loop_length|
      (0..sequence_length - loop_length * 2).each do |starting_index|
        # puts "first #{@sequence[starting_index, loop_length]}, second #{@sequence[starting_index + loop_length, loop_length]}"
        if @sequence[starting_index, loop_length] == @sequence[starting_index + loop_length, loop_length]
          # puts "DETECTED"
          return @sequence[starting_index, loop_length]
        end
      end
    end
  end
  
end

ProcessFile.new(filename) do |line|
  sequence = line.split(' ').map(&:to_i)
  puts LoopDetecter.new(sequence).to_s
end