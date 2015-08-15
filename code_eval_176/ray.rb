class Ray
  SIGN_VECTORS = {
    '/' => {
      upwards: {row: -1, column: 1},
      downwards: {row: 1, column: -1},
      to_right: {row: -1, column: 1},
      to_left: {row: 1, column: -1}
    },
    '\\' => {
      upwards: {row: -1, column: -1},
      downwards: {row: 1, column: 1},
      to_right: {row: 1, column: 1},
      to_left: {row: -1, column: -1}
    }
  }
  
  attr_accessor :row_pos, :column_pos, :length
  attr_reader :sign, :direction
  def initialize( row_pos, column_pos, sign, direction = nil, length = 1 )
    @row_pos = row_pos
    @column_pos = column_pos
    @sign = sign
    @direction = direction
    @length = length
    initial_vector
  end
  
  def new_splits
    ray_1 = Ray.new( *position, reflect_sign, direction, length )
    ray_2 = Ray.new( *position, reflect_sign, reflect_direction, length )
    return ray_1, ray_2
  end
  
  def reflect_direction
    case @direction
    when :to_right then :to_left
    when :to_left then :to_right
    when :upwards then :downwards
    when :downwards then :upwards
    end
  end
  
  def reflect_direction!
    @direction = reflect_direction
  end
  
  def reflect_sign
    case @sign
    when '/' then '\\'
    when '\\' then '/'
    end
  end
  
  def reflect_sign!
    @sign = reflect_sign
  end
  
  def next_position
    [@row_pos + @vector[:row], @column_pos + @vector[:column]]
  end
  
  def position
    [@row_pos, @column_pos]
  end
  
  def move
    @row_pos += @vector[:row]
    @column_pos +=  @vector[:column]
    @length += 1
  end
  
  def reflect_position
    @row_pos += @vector[:row] if (1..8).include?(@row_pos + @vector[:row]) 
    @column_pos +=  @vector[:column] if (1..8).include?(@column_pos + @vector[:column])

    reflect_sign!
    @direction = nil
    initial_vector
    @row_pos -= @vector[:row]
    @column_pos -= @vector[:column]
  end
  
  def initial_vector
    # @vector = [row_vector, column_vector]
    initial_direction
    @vector = SIGN_VECTORS[@sign][@direction]
  end
  
  # Rays can start at the border of map or by the wall
  # when created by reflection.
  # eg. Started Ray begin in 0 or 9 row/column position
  # Reflected Ray begin in 1 or 8 row/column position
  #
  def initial_direction
    return @direction if @direction
    @direction =  case
                  when [0, 1].include?(@column_pos) then :to_right
                  when [8, 9].include?(@column_pos) then :to_left
                  when [0, 1].include?(@row_pos) then :downwards
                  when [8, 9].include?(@row_pos) then :upwards
                  end
  end
end