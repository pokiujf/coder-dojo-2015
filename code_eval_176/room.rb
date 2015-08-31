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

  def process_action(action, ray)
    case action
      when :space
        set_element_in(*ray.position, ray.sign)
      when :perpendicular
        set_element_in(*ray.position, 'X')
      when :prism
        add_rays(ray.new_splits)
    end
  end

  def get_element_in(row, column)
    matrix[row][column]
  end

  def set_element_in(row, column, sign)
    matrix[row][column] = sign
  end

  def add_rays(new_rays)
    self.rays += new_rays.to_a
  end

  def remove_rays(removed_rays)
    self.rays -= removed_rays.to_a
  end

end