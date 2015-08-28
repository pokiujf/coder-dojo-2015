require '../support/process_file'
# require 'pry'
require_relative 'ray'
require_relative 'line_serializer'
require_relative 'presenter'
$env = 'show'

filename = ARGV[0] || 'data.txt'

class LightDistributor

  attr_accessor :rays
  attr_reader :matrix

  def initialize(matrix)
    @matrix = matrix
    @rays = []
  end

  def to_s
    distribute
    LineSerializer.deserialize(matrix)
  end

  private

  def distribute
    find_and_create_rays
    until @rays.empty?
      move(@rays)
      Presenter.draw_room(matrix)
    end
  end

  def move(rays)
    setup_holder_arrays

    rays.each do |light_ray|
      clear_position_and_element
      self.ray = light_ray
      next if ray_out_of_borders?
      next if ray_stops?
      step
    end

    update_rays

    unless @rays_to_move_again.empty?
      Presenter.put_delimiter
      move(@rays_to_move_again)
    end
  end

  def ray
    @ray
  end

  def ray=(light_ray)
    @ray = light_ray
  end

  def next_position
    @next_position ||= ray.next_position.values
  end

  def next_element
    @next_element ||= get_element_in(*next_position)
  end

  def update_rays
    @rays -= @rays_to_delete
    @rays += @rays_new
  end

  def setup_holder_arrays
    @rays_to_move_again = []
    @rays_new = []
    @rays_to_delete = []
  end

  def clear_position_and_element
    @next_position = nil
    @next_element = nil
  end

  def step
    case
      when next_element.is_space?
        ray.move
        set_element_in(*ray.position, ray.sign)
      when next_element.is_perpendicular_to?(ray.sign)
        ray.move
        set_element_in(*ray.position, 'X')
      when next_element.is_crossing? || next_element.is_ray?
        ray.move
      when next_element.is_prism?
        ray.move(prism: true)
        create_and_allocate_splits
      when next_element.is_wall?
        ray.reflect_position
        @rays_to_move_again << ray
    end
    Presenter.inspect_ray(@ray)
  end

  def ray_stops?
    if ray.length > 20 || next_position.is_corner? || next_element.is_pillar?
      @rays_to_delete << ray
      return true
    end
  end

  def ray_out_of_borders?
    if next_position.out_of_borders?
      @rays_to_delete << ray
      return true
    end
  end

  def get_element_in(row, column)
    @matrix[row][column]
  end

  def set_element_in(row, column, sign)
    @matrix[row][column] = sign
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

  def create_and_allocate_splits
    splits = ray.new_splits
    @rays_new += splits
    @rays_to_move_again += splits << ray
  end
end

ProcessFile.new(filename) do |line|
  puts LightDistributor.new(LineSerializer.serialize(line.strip)).to_s
end