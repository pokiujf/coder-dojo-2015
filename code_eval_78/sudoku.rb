require '../support/process_file.rb'

class SudokuChecker
  
  def initialize(data_line)
    size, sudoku_data = data_line.split(";")
    @size = size.to_i
    @size_root = Math.sqrt(@size).to_i
    @data = sudoku_data.split(",").map(&:to_i)
  end

  def grid_valid?
    return "False" unless @data.length == (@size ** 2)
    fill_fields.each do |field|
      return "False" unless all_numbers?(field)
    end
    "True"
  end
  
  private

  def fill_fields
    fields = []
    # rows
    @size.times do |n|
      fields << @data[@size * n, @size]
    end
  
    # columns
    @size.times do |n|
      column = []
      @size.times do |m|
        column << @data[@size * m + n]
      end
      fields << column
    end
  
    # squares
    @size_root.times do |square_row|
      @size_root.times do |square_num|
        square = []
        @size_root.times do |row|
          square << @data[index(square_row, square_num, row), @size_root]
        end
        fields << square.flatten
      end
    end
    fields
  end
  
  def index(square_row, square_num, row)
    square_row * (@size * @size_root) + square_num * @size + row * @size_root
  end

  def all_numbers?(field)
    reference_range = (1..@size).to_a
    field.each do |value|
      return false if reference_range.delete(value).nil?
    end
    reference_range.empty? ? true : false
  end
end

ProcessFile.new do |line|
  puts SudokuChecker.new(line.strip).grid_valid? unless line.strip.empty?
end
