require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class LightDistributor
  def initialize(matrix)
    @line = line
  end
  
  def to_s
    
  end
  
  private
  
  def method
    
  end
end

class Light
  @sign_vectors = {
    '/' => [[-1, 1], [1, -1]],
    '\\' => [[-1, -1], [1, 1]]
  }
  def initialize(x_pos, y_pos, sign)
    @x_pos = x_pos
    @y_pos = y_pos
    @sign = sign
    initial_vector
  end
  
  def initial_vector
    # @vector = [y_vector, x_vector]
    @vector = [0, 0]
    
    
    
  end
end

class LineSerializer
  def initialize(line)
    @matrix = []
    (0..10).each do |start|
      @matrix << line[start*10, 10]
    end
  end
  
  def serialize
    @matrix.pop
    @matrix.map{|row| row.split('')}
  end
end

ProcessFile.new(filename) do |line|
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize)
end