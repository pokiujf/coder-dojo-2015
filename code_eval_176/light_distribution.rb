require_relative '../support/process_file'
require 'pry'
require_relative 'ray'
require_relative 'line_serializer'
require_relative 'presenter'
require_relative 'room'
$env = 'show'

filename = ARGV[0] || 'data.txt'

class LightDistributor

  attr_reader :room

  def initialize(room)
    @room = room
  end

  def propagate
    until rays.empty?
      propagate_all(rays)
      Presenter.insert_room(matrix)
    end
    matrix
  end

  private

  def propagate_all(light_rays)
    light_rays.each do |light_ray|
      clear_position_and_element
      self.ray = light_ray
      next if ray_out_of_borders? || ray_stops?
      propagate_ray
    end
  end

  def propagate_ray
    case
      when next_element.is_space? then
        process_action(:space)
      # move
      # set_ray_sign
      when next_element.is_perpendicular_to?(sign) then
        process_action(:perpendicular)
      # move
      # set_crossing
      when next_element.is_crossing? then
        process_action(:crossing)
      # move
      when next_element.is_ray? then
        process_action(:parallel)
      # move
      when next_element.is_prism? then
        process_action(:prism)
      # move(prism: true)
      # create_splits
      when next_element.is_wall? then
        process_action(:wall)
      # reflect
      # propagate_all(ray.to_a)
    end
    Presenter.inspect_ray(ray)
  end

  def process_action(action)
    ray.process_action(action)
    room.process_action(action, ray)
  end

  def rays
    room.rays
  end

  def matrix
    room.matrix
  end

  def ray
    @ray
  end

  def ray=(light_ray)
    @ray = light_ray
  end

  # def move(args={})
  #   ray.move(args)
  # end

  def sign
    ray.sign
  end

  # def reflect
  #   ray.reflect_position
  # end

  def next_position
    @next_position ||= ray.next_position.values
  end

  def next_element
    @next_element ||= room.get_element_in(*next_position)
  end

  def clear_position_and_element
    @next_position = nil
    @next_element = nil
  end


  # def set_crossing
  #   room.set_element_in(*ray.position, 'X')
  # end
  #
  # def set_ray_sign
  #   room.set_element_in(*ray.position, ray.sign)
  # end

  def ray_stops?
    if ray.length > 20 || next_position.is_corner? || next_element.is_pillar?
      room.remove_rays(ray)
      return true
    end
  end

  def ray_out_of_borders?
    if next_position.out_of_borders?
      room.remove_rays(ray)
      return true
    end
  end

  # def create_splits
  #   room.add_rays(ray.new_splits)
  # end
end

ProcessFile.new(filename) do |line|
  room = Room.new(LineSerializer.serialize(line.strip))
  distributor = LightDistributor.new(room)
  puts LineSerializer.deserialize(distributor.propagate)

  decision = Presenter.put_description
  case decision
    when 'redo' then
      redo
    when 'exit'
      puts "Zamykam"
      break
  end
end