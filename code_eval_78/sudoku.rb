require '../support/process_file.rb'

class SudokuChecker
  attr_reader :line

  def initialize(line)
    @line=line
  end

  def data_prepare
    @size, sudoku_data = line.split(";")
    @size = @size.to_i
    @square = Math.sqrt(@size).to_i
    @data = sudoku_data.split(",").map(&:to_i)
    @fields = []
    rows
    columns
    squares
    @fields.flatten!(1)
  end
  
  def rows
    @rows ||= []
    @size.times do |n|
      @rows << @data[@size * n, @size]
    end
    @fields << @rows
  end
  
  def columns
    @columns ||= []
    @size.times do |n|
      column = []
      @size.times do |m|
        column << @data[@size * m + n]
      end
      @columns << column
    end
    @fields << @columns
  end
  
  def squares
    @squares ||= []
    @square.times do |square_row|
      @square.times do |square_num|
        square = []
        @square.times do |row|
          square << @data[square_index(square_row, square_num, row), @square]
        end
        @squares << square.flatten
      end
    end
    @fields << @squares
  end
  
  def square_index(square_row, square_num, row)
    square_row * (@size * @square) + square_num * @size + row * @square
  end
  
  def grid_valid?
    data_prepare
    @fields.each do |field|
      unless field.uniq.length == field.length
        return false
      end
    end
    return true
  end

end

ProcessFile.new do |line|
  puts SudokuChecker.new(line.chomp).grid_valid?
end
