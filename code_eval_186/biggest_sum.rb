require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class StockCalculator
  attr_reader :stock_values
  def initialize(days, stock_values)
    @days = days.to_i
    @stock_values = stock_values.split(' ').map(&:to_i)
  end
  
  def to_s
    max_gain = find_biggest_sum
    max_gain = 0 if max_gain < 0
    return max_gain
  end
  
  private
  
  def find_biggest_sum
    results = []
    (0..@stock_values.length - @days).each do |starting_index|
      results << stock_values[starting_index, @days].reduce(&:+)
    end
    results.max
  end
end

ProcessFile.new(filename) do |line|
  days, stock = line.split(';')
  puts StockCalculator.new(days, stock).to_s
end