require '../support/process_file'
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
      
      if $env
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
      next_position = ray.next_position
      if next_position.out_of_borders?
        @rays_to_delete << ray
        next
      end
      
      next_element = get_element_in( *next_position )
      step(ray, next_position, next_element)
    end
    
    @rays -= @rays_to_delete
    @rays += @rays_new
    
    puts '-' * 20 if $env && !@rays_to_move_again.empty?
    move(@rays_to_move_again) unless @rays_to_move_again.empty?
  end
    
  def step(ray, next_position, next_element)
    if ray_stops?(ray, next_position, next_element)
      @rays_to_delete << ray
      return
    end
      
    case 
    when next_element.is_space?
      ray.move
      set_element_in( *ray.position, ray.sign )
    when next_element.perpendicular_to_ray?( ray.sign )
      ray.move
      set_element_in( *ray.position, 'X' )
    when next_element.is_crossing? || next_element.is_ray?
      ray.move
    when next_element.is_prism?
      ray.move
      ray.length -= 1
      create_splits_of( ray )
    when next_element.is_wall?
      ray.reflect_position
      @rays_to_move_again << ray
    end
    puts ray.inspect if $env
  end
  
  def ray_stops?(ray, next_position, next_element)
    ray.length > 20 ||
    next_position.in_corner? ||
    next_element.is_pillar?
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
          @rays << Ray.new(row_index, column_index, item) 
        end
      end
    end
  end
  
  def create_splits_of( ray )
    splits = ray.new_splits
    @rays_new += splits
    @rays_to_move_again += splits << ray
  end
end

ProcessFile.new(filename) do |line|
  # puts LineSerializer.new(line.strip).serialize.to_s
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize).to_s
end