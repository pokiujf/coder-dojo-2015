class String

  ELEMENT_CODES = {
      'o' => :pillar,
      ' ' => :space,
      '*' => :prism,
      '#' => :wall,
      'X' => :crossing,
      '\\' => :ray,
      '/' => :ray
  }

  def to_matrix
    scan(/.{10}/).to_a
  end

  def code
    ELEMENT_CODES[self]
  end

  def is_ray?
    ELEMENT_CODES[self] == :ray
  end

  def is_pillar?
    ELEMENT_CODES[self] == :pillar
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

  def split_substring
    map{|sub_str| sub_str.split('')}
  end
end

class LineSerializer
  
  def self.serialize(line)
    matrix = line.to_matrix
    matrix.split_substring
  end

  def self.deserialize(matrix)
    matrix.double_join
  end

end