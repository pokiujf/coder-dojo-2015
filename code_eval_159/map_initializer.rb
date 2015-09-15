class MapInitializer
  class << self
    def setup(finder)
      data_parser.houses.each do |house|
        finder.houses << House.new(house)
      end
      data_parser.spots.each do |spot|
        finder.spots << Spot.new(spot).get_position
      end
    end

    private

    def data_parser
      @data_parser ||= DataParser.new(open_data).parse
    end

    def open_data
      File.open('data.txt').read
    end
  end
end