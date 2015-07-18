require '../support/process_file'

String.class_eval do
  def reverse_words
    self.strip.split.reverse.join(' ')
  end
end

ProcessFile.new do |line|
  puts line.reverse_words unless line.chomp.empty?
end