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
    # sequence_length / 2 because there is no need to search for loops
    # that are longer than half of the sequence
    (1..sequence_length / 2).each do |loop_length|
      
      # according to spec max loop length is 50 so no need to serach longer
      break if loop_length > 50
      
      # sequence_length - loop_length * 2 because there is no need to search for
      # n_num loop if thre is less than n numbers to the end of sequence
      (0..sequence_length - loop_length * 2).each do |starting_index|
        
        
        if loop_exist?(starting_index, loop_length)
          # puts "first #{@sequence[starting_index, loop_length]}, second #{@sequence[starting_index + loop_length, loop_length]}"
          return @sequence[starting_index, loop_length]
        end
      end
    end
  end
  
  def loop_exist?(start, length)
    @sequence[start, length] == @sequence[start + length, length]
  end
  
  def sequence_length
    @sequence_length ||= @sequence.length
  end
end

ProcessFile.new(filename) do |line|
  sequence = line.split(' ').map(&:to_i)
  puts LoopDetecter.new(sequence)
end