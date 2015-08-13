class String
  
  def to_matrix( row_length = 1 )
    scan(/.{#{row_length}}/).to_a
  end
  
  def is_ray?
    self == '/' || self == '\\'
  end
  
  def is_pillar?
    self == 'o'
  end
  
  def is_space?
    self == ' '
  end
  
  def is_prism?
    self == '*'
  end
  
  def is_wall?
    self == '#'
  end
  
  def is_crossing?
    self == 'X'
  end
  
  def perpendicular_to_ray?( ray_sign )
    self == '/' && ray_sign == '\\' || self == '\\' && ray_sign == '/'
  end
end

class Array
  
  def in_corner?
    # [[1, 1], [1, 8], [8, 1], [8, 8]].include? self
    [1, 8].repeated_permutation(2).to_a.include? self
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