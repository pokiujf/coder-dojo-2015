require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class Navigator
  def initialize(position, target)
    @position = position
    @target = target
  end
  
  def to_s
    show_way
  end
  
  private
  
  def show_way
    return 'here' if @position == @target
    response = ''
    if @target[1] > @position[1]
      response << 'N'
    elsif @target[1] < @position[1]
      response << 'S'
    end
    if @target[0] > @position[0]
      response << 'E'
    elsif @target[0] < @position[0]
      response << 'W'
    end
    response
  end
end

ProcessFile.new(filename) do |line|
  position = line.split(' ').map(&:to_i)
  target = position.pop(2)
  puts Navigator.new(position, target)
end