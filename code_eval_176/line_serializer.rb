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
  
  def is_perpendicular_to?( ray_sign )
    self == '/' && ray_sign == '\\' || self == '\\' && ray_sign == '/'
  end
end

class Array
  
  def is_corner?
    [0, 9].repeated_permutation(2).to_a.include? self
  end
  
  def out_of_borders?
    [-1, 10].include?(self[0]) || [-1, 10].include?(self[1])
  end
  
  def double_join
    map(&:join).join
  end
end

class LineSerializer
  
  def self.serialize(line)
    matrix = line.to_matrix( 10 )
    matrix.map{|row| row.split('')}
  end

  def self.deserialize(matrix)
    matrix.map(&:join).join
  end

end