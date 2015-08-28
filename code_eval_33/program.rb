require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class DoubleSquarer
  attr_reader :doubles

  def initialize(number)
    @number = number
    @doubles = []
  end

  def to_s
    find_double_squares
    @doubles.count
  end

  private

  def find_double_squares
    biggest = Math.sqrt(@number).floor
    (0..biggest).each do |num|
      if all_squares.include?(num**2) && all_squares.include?(@number - num**2)
        @doubles << [num**2, @number - num**2]
      end
    end
    @doubles.sort_by! { |sub_arr| sub_arr.sort_by! { |val| val }[0] }.uniq!
  end

  def all_squares
    @all_squares ||= (0..46_340).map { |root| root**2 }
  end
end

numbers = []
ProcessFile.new(filename) do |number|
  numbers << number.strip.to_i
end
number_of_cases = numbers.shift
numbers = numbers[0..number_of_cases-1]
numbers.each do |number|
  puts DoubleSquarer.new(number).to_s
end
