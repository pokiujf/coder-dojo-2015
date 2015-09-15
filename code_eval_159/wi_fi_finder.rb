require_relative 'monkey'
require_relative 'data_parser'
require_relative 'house'
require_relative 'spot'
require_relative 'map_initializer'

class Finder

  attr_accessor :houses, :spots
  def initialize(houses = [], spots = [])
    @houses = houses
    @spots = spots
  end
end

finder = Finder.new
MapInitializer.setup(finder)
binding.pry
