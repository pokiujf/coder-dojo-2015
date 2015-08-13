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
    @matrix.map{ |row| row.join }.join
  end
  
  private
  
  def distribute
    @rays << Ray.new(*get_ray)
    until @rays.empty?
      # puts "="*40
      move
      # puts @matrix.map{ |row| row.join }
      # gets
    end
  end
  
  def move( rays = @rays )
    new_rays = []
    rays.delete_if do |ray|
      next_position = ray.next_position
      
      ray.length > 20 ||
      next_position.out_of_borders? || 
      next_position.in_corner? || 
      get_element_in( *next_position ).is_pillar?
    end
    
    rays.each do |ray|
      
      next_position = ray.next_position
      element = get_element_in( *next_position )
      case 
      when element.is_space?
        ray.move
        set_element_in( *ray.position, ray.sign)
      when element.is_prism?
        ray.move
        new_ray_1 = Ray.new( *ray.position, ray.reflect_sign, ray.direction, ray.length )
        new_ray_2 = Ray.new( *ray.position, ray.reflect_sign, ray.reflect_direction, ray.length )
        new_rays << ray
        @rays << new_ray_1 << new_ray_2
      when element.is_wall?
        ray.reflect_position
        new_rays << ray
      when element.perpendicular_to_ray?( ray.sign )
        ray.move
        set_element_in( *ray.position, 'X')
      when element.is_crossing?
        ray.move
      when element.is_ray?
        ray.move
      end
      # puts ray.inspect
    end
    unless new_rays.empty?
      # puts '-' * 20
      move( new_rays ) 
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
  # puts LineSerializer.new(line.strip).serialize.to_s
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize).to_s
end