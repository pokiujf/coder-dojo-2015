require '../support/process_file'

class DnaMatcher
  
  attr_reader :segment, :precission, :code, :matches
  def initialize(segment, precission, code)
    @segment = segment.split('')
    @precission = precission.to_i
    @code = code.split('')
    @matches = []
    search_matches
  end
  
  def search_matches
    while @code.size >= @segment.size
      taken = @code.take(@segment.size)
      eval_taken(taken)
      @code.shift
    end
    sort_matches
    clear_values
  end
  
  def sort_matches
    @matches_by_num = []
    (0..@precission).each do |errors|
      @matches_by_num << @matches.select{|match_arr| match_arr.first == errors}
    end
    @matches_by_num.each do |precission_matches|
      precission_matches.sort_by!{|match_arr| match_arr.last }
    end
  end
  
  def clear_values
    @matches = @matches_by_num.flatten.select{|item| item.is_a? String}.join(' ')
    @matches = 'No match' if @matches.empty?
  end
  
  def eval_taken(taken)
    taken_errors = 0
    @segment.each_with_index do |correct_letter, index|
      unless taken[index] == correct_letter
        taken_errors += 1
        return false if taken_errors > @precission
      end
    end
    @matches << [taken_errors, taken.join]
    true
  end
  
end


ProcessFile.new do |line|
  puts DnaMatcher.new(*line.split).matches
end