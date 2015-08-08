lines = [
  "2 0 6 3 1 6 3 1 6 3 1",
  "3 4 8 0 11 9 7 2 5 6 10 1 49 49 49 49",
  "1 2 3 1 2 3 1 2 3"
  ]


def find_loop(line)
  max_chars = 50 > (line.length / 2) ? line.length / 2 : 50
  # puts "max_chars = #{max_chars}"
  (1..max_chars).each do |num_of_chars|
    (0..line.length-num_of_chars*2).each do |start_char_pos|
      search_chars = line[start_char_pos, num_of_chars]
      # puts "search_chars = #{search_chars}"
      line.match(/(#{search_chars}){2,}/) {|found|
        # puts "found #{found}"
        return search_chars.split('').join(' ')
      }
    end
  end
  nil
end

File.open(ARGV[0], 'r').each_line do |line|
  line_matches = []

  loop_in = find_loop(line.gsub(' ', ''))
  puts loop_in unless loop_in.nil?
end