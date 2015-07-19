require '../support/process_file.rb'

class PositionChecker
  
  def initialize(data)
    data = data.split(',')
    @binary = data.shift.to_i.to_s(2)
    @bits = data.map!(&:to_i)
  end
  
  def bits_in_position?
    @bits.each do |bit_position|
      unless @binary[-bit_position] == '1'
        return false
      end
    end
    true
  end
  
end

ProcessFile.new do |line|
  puts PositionChecker.new(line).bits_in_position? unless line.strip.empty?
end
