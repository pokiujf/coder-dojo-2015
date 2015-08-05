require '../support/process_file.rb'

class Sudoku
  class Checker
    
    def initialize(size, data)
      @size = size
      @size_root = Math.sqrt(@size).to_i
      @data = data
    end
  
    def grid_valid?
      return "False" unless proper_chunks_length?
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
      @size_root.times do |row_of_squares|
        @size_root.times do |number_in_row|
          square = []
          @size_root.times do |row_in_square|
            element = @data[index(row_of_squares, number_in_row, row_in_square), @size_root]
            square << element
          end
          fields << square.flatten
        end
      end
      fields
    end
    
    def index(row_of_squares, number_in_row, row_in_square)
      row_of_squares * (@size * @size_root) + row_in_square * @size + number_in_row * @size_root
    end
  
    def all_numbers?(field)
      reference_range = (1..@size).to_a
      field.each do |value|
        return false if reference_range.delete(value).nil?
      end
      reference_range.empty? ? true : false
    end
    
    def proper_chunks_length?
      @data.sort.chunk{|v| v }.map(&:last).all?{|v| v.length == @size }
    end
  end
  
  class LineParser
    
    def parse(line)
      splitten = line.strip.match(/(?<size>\d);(?<numbers>(\d(,)?)+)/)
      [splitten['size'].to_i, splitten['numbers'].split(',').map(&:to_i)]
    end
  end
end

ProcessFile.new do |line|
  puts Sudoku::Checker.new(*Sudoku::LineParser.new.parse(line)).grid_valid? unless line.strip.empty?
end
