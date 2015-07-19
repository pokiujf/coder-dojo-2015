class MultiplicationTable
  attr_reader :table
  def initialize(size_x, size_y)
    @size_x = size_x
    @size_y = size_y
    @table = []
    generate
  end
  
  def generate
    @table = (1..@size_y).map do |y_val|
      (1..@size_x).map { |x_val| (x_val * y_val).to_s.rjust(4,' ') }
    end
  end
  
  def to_s
    result = @table.map { |y_table| y_table.join + "\n" }
    result.join
  end
end

puts MultiplicationTable.new(12, 12)