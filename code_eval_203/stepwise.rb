require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class Stepwiser
  def initialize(word)
    @word = word
    @response = ''
  end
  
  def to_s
    convert
    @response.strip
  end
  
  private
  
  def convert
    @word.split('').each_with_index do |letter, index|
      @response << "#{'*' * index}#{letter} "
    end
  end
end

ProcessFile.new(filename) do |line|
  puts Stepwiser.new(line.strip.split(' ').max_by(&:length)).to_s
end