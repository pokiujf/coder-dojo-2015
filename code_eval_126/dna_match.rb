require '../support/process_file'

class DnaMatcher
  
  attr_reader :segment, :precission, :code
  def initialize(segment, precission, code)
    @segment = segment.split('')
    @precission = precission.to_i
    @code = code.split('')
    @matches = []
  end
  
  def search_matches
    while @code.size >= @segment.size
      taken = @code.take(@segment.size)
      eval_taken(taken)
      @code.shift
    end
    matches_by_num = []
    (0..@precission).each do |errors|
      matches_by_num << @matches.select{|match_arr| match_arr.first == errors}
    end
    matches_by_num.each do |precission_matches|
      precission_matches.sort_by!{|match_arr| match_arr.last}
    end
    return matches_by_num
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
  matcher = DnaMatcher.new(*line.split)
  matches = matcher.search_matches
  
  
  puts "#{matcher.segment.join}, #{matches}"
  
end