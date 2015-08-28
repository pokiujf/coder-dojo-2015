require '../support/process_file'
# require 'pry'
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

  def distribute
    until rays.empty?
      propagate_all(rays)
      Presenter.draw_room(matrix)
    end
    matrix
  end

  private

  def rays
    room.rays
  end

  def matrix
    room.matrix
  end

  def propagate_all(light_rays)
    setup_holder_arrays

    light_rays.each do |light_ray|
      clear_position_and_element
      self.ray = light_ray
      next if ray_out_of_borders? || ray_stops?
      propagate_ray
    end

    add_or_remove_rays

    unless @rays_to_move_again.empty?
      Presenter.put_delimiter
      propagate_all(@rays_to_move_again)
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
    @next_element ||= room.get_element_in(*next_position)
  end

  def add_or_remove_rays
    room.rays -= @rays_to_delete
    room.rays += @rays_new
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

  def propagate_ray
    case
      when next_element.is_space?
        ray.move
        set_ray_sign
      when next_element.is_perpendicular_to?(ray.sign)
        ray.move
        set_ray_crossing
      when next_element.is_crossing? || next_element.is_ray?
        ray.move
      when next_element.is_prism?
        ray.move(prism: true)
        create_and_allocate_splits
      when next_element.is_wall?
        ray.reflect_position
        @rays_to_move_again << ray
    end
    Presenter.inspect_ray(ray)
  end

  def set_ray_crossing
    room.set_element_in(*ray.position, 'X')
  end

  def set_ray_sign
    room.set_element_in(*ray.position, ray.sign)
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

  def create_and_allocate_splits
    splits = ray.new_splits
    @rays_new += splits
    @rays_to_move_again += splits << ray
  end
end

ProcessFile.new(filename) do |line|
  room = Room.new(LineSerializer.serialize(line.strip))
  response = LightDistributor.new(room).distribute
  puts LineSerializer.deserialize(response)
  puts "To cała ścieżka rozchodzenia się światła w tym pokoju.\n\n-\tJeśli chcesz obejrzeć ponownie wpisz: redo\n\t\ti potwierdź ENTER\n-\tAby zakończyć wpisz: exit\n\t\ti wciśnij ENTER\n-\tAby przejśc do następnego pokoju: wciśnij ENTER."
  decision = gets.chomp
  system('clear')
  case decision
    when 'redo' then
      redo
    when 'exit'
      puts "Zamykam"
      break
  end
end