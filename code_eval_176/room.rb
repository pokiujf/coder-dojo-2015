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
        set_element(ray)
      when :perpendicular
        set_element(ray, 'X')
      when :prism
        add_rays(ray.new_splits)
      when :removal
        remove_rays(ray)
    end
  end

  def get_element_in(row, column)
    matrix[row][column]
  end

  private

  def set_element(ray, sign=nil)
    row, column = ray.position
    sign = sign || ray.sign
    matrix[row][column] = sign
  end

  def add_rays(new_rays)
    @rays += new_rays.to_a
  end

  def remove_rays(removed_rays)
    @rays -= removed_rays.to_a
  end
end