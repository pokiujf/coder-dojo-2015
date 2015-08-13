require '../support/process_file'
require 'line_serializer'
require 'light'
filename = ARGV[0] || 'data.txt'

class LightDistributor
  def initialize(matrix)
    @matrix = matrix
  end
  
  def to_s
    distribute
  end
  
  private
  
  def distribute
    puts get_light
    Light.new(get_light)
  end
  
  def get_element_in( row, column )
    @matrix[row][column]
  end
  
  def get_light
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        return [row_index, column_index, item] if item == '/' || item == '\\'
      end
    end
  end
end

ProcessFile.new(filename) do |line|
  puts LineSerializer.new(line.strip).serialize.to_s
  puts LightDistributor.new(LineSerializer.new(line.strip).serialize)
end