require 'pry'
class DataParser
  attr_reader :houses, :logs

  def initialize(data)
    @houses, @logs = data.strip.split("\n\n")
  end

  def parse
    @houses = @houses.split("\n")
    @logs = @logs.split("\n")
    parse_houses
    parse_logs
    self
  end

  private

  def parse_houses
    struct_for_house
    houses.map! do |house_data|
      name, *coords = house_data.split
      coords.map! do |point|
        Struct::Coordinate.new(*point.to_coord!)
      end
      Struct::HouseData.new(name, coords)
    end
  end

  def parse_logs
    struct_for_log
    logs.map! do |log_data|
      coord, *entries = log_data.split
      coord = coord.to_coord!
      entries.map! do |entry|
        entry = entry.split(";")
        entry[1] = entry[1].to_f
        Struct::Entry.new(*entry)
      end
      Struct::LogData.new(coord, entries)
    end
  end

  def struct_for_house
    Struct.new('HouseData', :name, :coords)
    Struct.new('Coordinate', :x_pos, :y_pos)
  end

  def struct_for_log
    Struct.new('LogData', :point, :entries)
    Struct.new('Entry', :mac, :azimuth)
  end
end


binding.pry