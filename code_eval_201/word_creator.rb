require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class WordCreator
  def initialize(word, letters)
    @word = word
    @letters = letters
  end
  
  def to_s
    creatable?.to_s.capitalize
  end
  
  private
  
  def creatable?
    results = []
    @word.each_char do |letter|
      (0..@letters.length-1).each do |block_index|
        # puts "#{@letters[block_index]}, #{letter}, #{@letters[block_index].include? letter}"
        if @letters[block_index].include? letter
          @letters.delete_at(block_index)
          # puts @letters.to_s
          results << true
          break
        end
      end
    end
    results.length == @word.length
  end
end

ProcessFile.new(filename) do |line|
  num, word, letters = line.split(' | ')
  letters = letters.split(' ')
  puts WordCreator.new(word, letters)
end