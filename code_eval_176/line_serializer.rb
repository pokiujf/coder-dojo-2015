class String
  
  def to_matrix( row_length = 1 )
    scan(/.{#{row_length}}/).to_a
  end
end

class LineSerializer
  
  def initialize(line)
    @matrix = []
    @line = line
  end
  
  def serialize
    @matrix = @line.to_matrix( 10 )
    @matrix.map{|row| row.split('')}
  end
end