class MapInitializer
  class << self
    def setup
      data_parser.houses.each do |house|

      end
    end


    private
    def data_parse
      @data_parser ||= DataParser.new(open_data).parse
    end

    def open_data
      File.open('data.txt').read
    end
  end
end