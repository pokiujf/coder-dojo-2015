class Room

  attr_reader :matrix
  attr_accessor :rays
  def initialize(matrix)
    @matrix = matrix
    @rays = []
    find_and_create_rays
  end

  def find_and_create_rays
    matrix.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        if item.is_ray?
          rotation = Ray.get_rotation_for(row_index, column_index, item)
          rays << Ray.new(row_index, column_index, rotation)
        end
      end
    end
  end

  def get_element_in(row, column)
    matrix[row][column]
  end

  def set_element_in(row, column, sign)
    matrix[row][column] = sign
  end

end