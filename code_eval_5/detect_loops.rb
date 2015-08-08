require '../support/process_file'
filename = ARGV[0] || 'sequences.txt'

class LoopDetecter
  
  def initialize(sequence)
    @sequence = sequence
  end
  
  def to_s
    detect
  end
  
  private
  
  def detect
    
  end
  
end

ProcessFile.new(filename) do |line|
  sequence = line.split(' ').map(&:to_i)
  puts LoopDetecter.new(sequence)
end