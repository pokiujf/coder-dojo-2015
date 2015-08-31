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
  attr_accessor :ray

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
      if ray_out_of_borders? || ray_stops?
        room.process_action(:removal, ray)
        next
      end
      propagate_ray
    end
  end

  def propagate_ray
    case
      when next_element.is_space? then
        process_action(:space)
      when next_element.is_perpendicular_to?(sign) then
        process_action(:perpendicular)
      when next_element.is_crossing? then
        process_action(:crossing)
      when next_element.is_ray? then
        process_action(:parallel)
      when next_element.is_prism? then
        process_action(:prism)
      when next_element.is_wall? then
        process_action(:wall)
    end
    Presenter.inspect_ray(ray)
  end

  def process_action(action, opts = {})
    ray.process_action(action)
    room.process_action(action, ray)
  end

  def rays
    room.rays
  end

  def remove_rays(ray)
    room.remove_rays(ray)
  end

  def matrix
    room.matrix
  end

  def sign
    ray.sign
  end

  def next_position
    @next_position ||= ray.next_position.values
  end

  def next_element
    @next_element ||= room.get_element_in(*next_position)
  end

  def clear_position_and_element
    @next_position = @next_element = nil
  end

  def ray_stops?
    ray.length > 20 || next_position.is_corner? || next_element.is_pillar?
  end

  def ray_out_of_borders?
    next_position.out_of_borders?
  end
end

ProcessFile.new(filename) do |line|
  room = Room.new(LineSerializer.serialize(line.strip))
  distributor = LightDistributor.new(room)
  puts LineSerializer.deserialize(distributor.propagate)

  decision = Presenter.put_description
  case decision
    when 'redo'
      redo
    when 'exit'
      puts "Zamykam"
      break
  end
end