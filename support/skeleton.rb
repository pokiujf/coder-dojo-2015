require '../support/process_file'
filename = ARGV[0] || '.txt'

class NAME
  def initialize(line)
    @line = line
  end
  
  def to_s
    
  end
  
  private
  
  def method
    
  end
end

ProcessFile.new(filename) do |line|
  # line = line.split(' ').map(&:to_i)
  puts NAME.new(line)
end