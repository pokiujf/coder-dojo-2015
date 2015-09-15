# require 'Math'
class Spot
  extend Forwardable

  def_delegators :@spot_data, :mac, :entries
  def initialize(spot_data)
    @spot_data = spot_data
    @position = nil
  end

  def get_position
    entry = entries.first(2)
    return if entry.count != 2
    y1 = entry[0].coord.y_pos
    y2 = entry[1].coord.y_pos
    x1 = entry[0].coord.x_pos
    x2 = entry[1].coord.x_pos
    alfa1 = entry[0].azimuth * Math::PI / 180.0
    alfa2 = entry[1].azimuth * Math::PI / 180.0
    tg1 = Math.tan(alfa1)
    tg2 = Math.tan(alfa2)
    x3 = ((y2 - y1) * tg1 * tg2 + x1 * tg2 - x2 * tg1) / (tg2 - tg1)
    y3 = (x3 - x1) / tg1 + y1
    @position = Struct::Coordinate.new(x3.round(2), y3.round(2))
    self
  end
end