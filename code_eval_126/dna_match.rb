require '../support/process_file'

class DnaMatcher
  
  attr_reader :segment, :precission, :code
  def initialize(segment, precission, code)
    @segment = segment
    @precission = precission.to_i
    @code = code
  end
  
end



ProcessFile.new do |line|
  matcher = DnaMatcher.new(*line.split)
  puts matcher.segment
  puts matcher.precission
  puts matcher.code
  
end