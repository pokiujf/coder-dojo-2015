require_relative '../support/process_file'
require 'pry'
require_relative 'ray'
require_relative 'line_serializer'
require_relative 'presenter'
require_relative 'room'

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
      setup_ray(light_ray)
      next if ray_finished?
      perform_action_for(next_element.code)
      Presenter.inspect_ray(ray)
    end
  end

  def perform_action_for(code, opts = {})
    code = :perpendicular if next_element.is_perpendicular_to?(sign)
    ray.process_action(code)
    room.process_action(code, ray)
    propagate_all(ray.to_a) if code == :wall
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

  def setup_ray(light_ray)
    @next_position = @next_element = nil
    @ray = light_ray
  end

  def ray_finished?
    if ray_stops?
      room.process_action(:removal, ray)
      true
    end
  end

  def ray_stops?
    ray.length > 20 || next_position.out_of_borders? ||
        next_position.is_corner? || next_element.is_pillar?
  end
end

class Runner
  def self.run
    filename = ARGV[0] || 'data.txt'
    # Presenter.env ||= 'show'
    ProcessFile.new(filename) do |line|
      create_room(line)
      distribute_light
      deserialize_response
      puts @deserialized_room if $env == 'prod'

      case Presenter.put_description
        when 'redo'
          redo
        when 'exit'
          puts "Zamykam"
          break
      end
    end
  end

  def self.create_room(line)
    @room = Room.new(serialize_line(line))
  end

  def self.serialize_line(line)
    LineSerializer.serialize(line.strip)
  end

  def self.distribute_light
    @response = LightDistributor.new(@room).propagate
  end

  def self.deserialize_response
    @deserialized_room = LineSerializer.deserialize(@response)
  end
end

Runner.run




