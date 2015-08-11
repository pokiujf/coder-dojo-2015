require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class BigNumPrinter
  MAPPING = [
    ['-**--','*--*-','*--*-','*--*-','-**--','-----'],
    ['--*--','-**--','--*--','--*--','-***-','-----'],
    ['***--','---*-','-**--','*----','****-','-----'],
    ['***--','---*-','-**--','---*-','***--','-----'],
    ['-*---','*--*-','****-','---*-','---*-','-----'],
    ['****-','*----','***--','---*-','***--','-----'],
    ['-**--','*----','***--','*--*-','-**--','-----'],
    ['****-','---*-','--*--','-*---','-*---','-----'],
    ['-**--','*--*-','-**--','*--*-','-**--','-----'],
    ['-**--','*--*-','-***-','---*-','-**--','-----']
    
    ]
  def initialize(num_arr)
    @num_arr = num_arr
  end
  
  def to_s
    stretch
  end
  
  private
  
  def stretch
    response = ""
    6.times do |row|
      @num_arr.each do |number|
        response << MAPPING[number][row]
      end
      response << "\n"
    end
    return response
  end
end

ProcessFile.new(filename) do |line|
  num_arr = line.scan(/\d/).map(&:to_i)
  puts BigNumPrinter.new(num_arr)
end