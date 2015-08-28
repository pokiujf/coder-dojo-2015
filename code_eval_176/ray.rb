class Ray
  ROTATIONS = {
    45 => {sign: '/', vector: {row: -1, column: 1}},
    135 => {sign: '\\', vector: {row: 1, column: 1}},
    225 => {sign: '/', vector: {row: 1, column: -1}},
    315 => {sign: '\\', vector: {row: -1, column: -1}}
  }
  ROTATION_REFLECTIONS = {
    top: {
      315 => 225,
      45 => 135
    },
    bottom: {
      225 => 315,
      135 => 45
    },
    right: {
      45 => 315,
      135 => 225
    },
    left: {
      315 => 45,
      225 => 135
    }
  }
  
  attr_accessor :row_pos, :column_pos, :length, :rotation
  def initialize( row_pos, column_pos, rotation, length = 1 )
    @row_pos = row_pos
    @column_pos = column_pos
    @rotation = rotation
    @length = length
  end
  
  def self.get_rotation_for( row, column, sign )
    if sign == '/'
      return 45 if row == 9 || column == 0
      return 225 if row == 0 || column == 9
    elsif sign == '\\'
      return  135 if row == 0 || column == 0
      return 315 if row == 9 || column == 9
    end
  end
  
  def new_splits
    rotations = split_rotations.map do |rotation|
      Ray.new( *position, rotation, length )
    end
    return rotations
  end
  
  def split_rotations
    [(rotation - 90) % 360, (rotation + 90) % 360]
  end
  
  def sign
    ROTATIONS[rotation][:sign]
  end
  
  def vector
    ROTATIONS[rotation][:vector]
  end
  
  def next_position
    {
      row: row_pos + vector[:row],
      column: column_pos + vector[:column]
    }
  end
  
  def position
    [row_pos, column_pos]
  end
  
  def move( opts = {} )
    self.row_pos, self.column_pos = next_position.values
    self.length += 1 unless opts[:prism]
  end
  
  def reflect_position
    self.row_pos = next_position[:row] if [0, 9].include?(next_position[:row])
    self.column_pos = next_position[:column] if [0, 9].include?(next_position[:column])
    self.rotation = ROTATION_REFLECTIONS[reflection_side][rotation]
  end
  
  def reflection_side
    case
    when next_position[:column] == -1 then :left
    when next_position[:column] == 10 then :right
    when next_position[:row] == -1 then :top
    when next_position[:row] == 10 then :bottom
    end
  end
end