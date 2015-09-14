class House
  extend Forwardable

  def_delegators :@house_data, :name, :coords
  def initialize(house_data)
    @house_data = house_data
  end
end