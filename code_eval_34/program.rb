require '../support/process_file'
filename = ARGV[0] || 'data.txt'

class PairFinder
  attr_reader :pairs

  def initialize(numbers, sum)
    @numbers = numbers
    @sum = sum
    @pairs = []
  end

  def find_pairs
    @numbers.each { |number| @pairs << find_pair_for(number) }
  end

  def prepare_pairs
    @pairs.compact!
    @pairs.map { |pair| pair.sort! }
    @pairs.uniq!
    if @pairs.empty?
      @pairs = 'NULL'
    else
      @pairs = @pairs.map { |sub_arr| sub_arr.join(',') }.join(';')
    end
  end

  private

  def find_pair_for(number)
    pair = []
    if @numbers.include?(@sum - number)
      pair << number << @sum - number
    end
  end
end

ProcessFile.new(filename) do |line|
  next if line.strip.empty?
  numbers, sum = line.split(';')
  sum = sum.to_i
  numbers = numbers.split(',').map(&:to_i)

  finder = PairFinder.new(numbers, sum)
  finder.find_pairs
  finder.prepare_pairs
  puts finder.pairs
end