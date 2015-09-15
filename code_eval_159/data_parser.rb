require 'pry'
require_relative 'monkey'
class DataParser
  attr_reader :houses, :spots

  def initialize(data)
    @houses, @logs = data.strip.split("\n\n")
    @spots = []
  end

  def parse
    @houses = @houses.split("\n")
    @logs = @logs.split("\n")
    setup_structures
    parse_houses
    parse_logs
    self
  end

  private

  def parse_houses
    houses.map! do |house_data|
      name, *coords = house_data.split
      coords.map! do |point|
        point.to_coord!
      end
      {name: name, coords: coords}
    end
  end

  def parse_logs
    collector = {}
    @logs.each do |log_data|
      coord, *entries = log_data.split
      next if entries.empty?
      entries.each do |entry|
        mac, azimuth = entry.split(';')
        azimuth = azimuth.to_f
        coordinate = coord.split(';').map(&:to_f)
        collector[mac] = [] if collector[mac] == nil
        collector[mac] << [azimuth, coordinate]
      end
    end
    collector.each do |mac, entries|
      spot = Struct::HotSpot.new(mac, [])
      spot = {mac: mac, entries: []}
      entries.each do |entry|
        coord = Struct::Coordinate.new(*entry[1])
        spot.entries << Struct::RadarEntry.new(entry[0], coord)
      end
      @spots << spot
    end
  end

  def setup_structures
    Struct.new('HouseData', :name, :coords)
    Struct.new('Coordinate', :x_pos, :y_pos)
    Struct.new('RadarEntry', :azimuth, :coord)
    Struct.new('HotSpot', :mac, :entries)
  end
end

data_parser = DataParser.new(File.open('data.txt').read).parse
binding.pry