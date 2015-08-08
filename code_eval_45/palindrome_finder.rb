require '../support/process_file'
filename = ARGV[0] || 'starters.txt'

class PalindromeFinder
  attr_reader :iteration
  def initialize(starter)
    @starter = starter
    @iteration = 0
  end
  
  def to_s
    palindrome = find(@starter)
    "#{@iteration} #{palindrome}"
  end
  
  private
  
  def find(number)
    if number.palindrome?
      return number
    else
      @iteration += 1
      find(number + number.to_s.reverse.to_i)
    end
  end
end

class Integer
  def palindrome?
    self.to_s == self.to_s.reverse
  end
end

ProcessFile.new(filename) do |starter|
  puts PalindromeFinder.new(starter.strip.to_i)
end