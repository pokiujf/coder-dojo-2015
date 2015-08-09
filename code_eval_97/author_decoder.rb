require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class AuthorDecoder
  def initialize(letters, numbers)
    @letters = letters
    @numbers = numbers
  end
  
  def to_s
    decrypt
  end
  
  private
  
  def decrypt
    result = @numbers.map do |number|
      @letters[number]
    end
    result.join.to_s
  end
end

ProcessFile.new(filename) do |line|
  letters, numbers = line.strip.split('| ')
  letters = ' ' + letters
  numbers = numbers.split(' ').map(&:to_i)
  puts AuthorDecoder.new(letters, numbers).to_s
end