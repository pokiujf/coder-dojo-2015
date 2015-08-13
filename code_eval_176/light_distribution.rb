require '../support/process_file'
require_relative 'ray.rb'
require_relative 'line_serializer.rb'
filename = ARGV[0] || 'data.txt'

class LightDistributor
  def initialize(matrix)
    @matrix = matrix
    @rays = []
  end
  
  def to_s
    distribute
  end
  
  private
  
  def distribute
    @rays << Ray.new(*get_ray)
    until @rays.empty?
      move
    end
  end
  
  def move
    @rays.delete_if do |ray|
      next_position = ray.next_position
      element = get_element_in( *next_position )
      
      next_position.in_corner? || element.is_pillar?
    end
    
    @rays.each do |ray|
      next_position = ray.next_position
      
      case get_element_in( *next_position )
      when is_space?
        ray.move
        set_element_in( *ray.position, ray.sign)
      when is_prism?
        # create 2 perpendicular rays in proper positions
        # ray.move
        # do not set_element_in position
      when is_wall?
        ray.reflect
      when perpendicular_to_ray?
        ray.move
        set_element_in( *ray.position, 'X')
      when is_crossing?
        ray.move
      end
    end
  end
  
  def get_element_in( row, column )
    @matrix[row][column]
  end
  
  def set_element_in ( row, column, sign )
    @matrix[row][column] = sign
  end
  
  def get_ray
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        return [row_index, column_index, item] if item.is_ray?
      end
    end
  end
end

ProcessFile.new(filename) do |line|
  puts LineSerializer.new(line.strip).serialize.to_s
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize)
end