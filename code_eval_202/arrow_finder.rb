require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class ArrowFinder
  def initialize(line)
    @line = line
    @arrows = 0
  end
  
  def to_s
    find
    @arrows
  end
  
  private
  
  def find
    (0..@line.length - 5).each do |start_index|
      if @line[start_index, 5].match(/<--<</)
        @arrows += 1
        @line.slice(start_index, 4)
      elsif @line[start_index, 5].match(/>>-->/)
        @arrows += 1
        @line.slice(start_index, 4)
      end
    end
  end
end

ProcessFile.new(filename) do |line|
  puts ArrowFinder.new(line.strip).to_s
end