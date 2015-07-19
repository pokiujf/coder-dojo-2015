require '../support/process_file.rb'

class PositionChecker
  
  def initialize(data)
    @decimal, @bit1, @bit2 = data.split(',').map(&:to_i)
  end
  
  def bits_in_position?
    bit_ary = @decimal.to_s(2).insert(-1, '-').reverse
    bit_ary[@bit1] == '1' && bit_ary[@bit2] == '1'
  end
  
end

ProcessFile.new do |line|
  puts PositionChecker.new(line).bits_in_position? unless line.strip.empty?
end
