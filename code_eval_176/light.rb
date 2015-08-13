class Light
  SIGN_VECTORS = {
    '/' => {
      upwards: [-1, 1],
      downwards: [1, -1],
      to_right: [-1, 1],
      to_left: [1, -1]
    },
    '\\' => {
      upwards: [-1, -1],
      downwards: [1, 1],
      to_right: [1, 1],
      to_left: [-1, -1]
    }
  }
  def initialize(row_pos, column_pos, sign)
    @row_pos = row_pos
    @column_pos = column_pos
    @sign = sign
    initial_vector
  end
  
  def initial_vector
    # @vector = [row_vector, column_vector]
    @vector = SIGN_VECTORS[@sign][initial_direction]
  end
  
  def initial_direction
    case
    when @column_pos == 0 then :to_right
    when @column_pos == 10 then :to_left
    when @row_pos == 0 then :upwards
    when @row_pos == 10 then :downwards
    end
  end
end