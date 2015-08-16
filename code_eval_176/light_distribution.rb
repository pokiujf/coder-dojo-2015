require '../support/process_file'
require 'pry'
require_relative 'ray.rb'
require_relative 'line_serializer.rb'
$env = 'development'

filename = ARGV[0] || 'data.txt'

class LightDistributor
  def initialize(matrix)
    @matrix = matrix
    @rays = []
  end
  
  def to_s
    distribute
    @matrix.double_join
  end
  
  private
  
  def distribute
    find_and_create_rays
    until @rays.empty?
      move( @rays )
      
      if $env == 'show' || $env == 'development'
        puts @matrix.map{ |row| row.join }
        gets
      end
      
    end
  end
  
  def move( rays )
    @rays_to_move_again = []
    @rays_new = []
    @rays_to_delete = []
    
    rays.each do |ray|
      next_position = ray.next_position.values
      next if ray_out_of_borders?( ray, next_position )
      next_element = get_element_in( *next_position )
      next if ray_stops?(ray, next_position, next_element)
      step(ray, next_element)
    end
    
    @rays -= @rays_to_delete
    @rays += @rays_new
    
    puts '-' * 20 if $env == 'development' && !@rays_to_move_again.empty?
    move(@rays_to_move_again) unless @rays_to_move_again.empty?
  end
    
  def step(ray, next_element)
    case 
    when next_element.is_space?
      ray.move
      set_element_in( *ray.position, ray.sign )
    when next_element.is_perpendicular_to?( ray.sign )
      ray.move
      set_element_in( *ray.position, 'X' )
    when next_element.is_crossing? || next_element.is_ray?
      ray.move
    when next_element.is_prism?
      ray.move( prism: true )
      create_and_allocate_splits_of( ray )
    when next_element.is_wall?
      ray.reflect_position
      @rays_to_move_again << ray
    end
    puts ray.inspect if $env == 'development'
  end
  
  def ray_stops?(ray, next_position, next_element)
    if ray.length > 20 || next_position.is_corner? || next_element.is_pillar?
      @rays_to_delete << ray
      return true
    end
  end
  
  def ray_out_of_borders?(ray, next_position)
    if next_position.out_of_borders?
      @rays_to_delete << ray
      return true
    end
  end
  
  def get_element_in( row, column )
    @matrix[row][column]
  end
  
  def set_element_in ( row, column, sign )
    @matrix[row][column] = sign
  end
  
  def find_and_create_rays
    @rays = []
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        if item.is_ray?
          rotation = Ray.get_rotation_for( row_index, column_index, item)
          @rays << Ray.new(row_index, column_index, rotation)
        end
      end
    end
  end
  
  def create_and_allocate_splits_of( ray )
    splits = ray.new_splits
    @rays_new += splits
    @rays_to_move_again += splits << ray
  end
end

ProcessFile.new(filename) do |line|
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize).to_s
end