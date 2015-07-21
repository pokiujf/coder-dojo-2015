class GameOfLife
  
  attr_reader :grid, :size_x, :size_y
  def initialize(grid)
    @grid = grid.split("\n").map{|row| row.split('')}
    @size_x = @grid.first.size
    @size_y = @grid.size
  end
  
  def play(rounds)
    rounds.times {|n| play_round}
  end
  
  def play_round
    round_grid = []
    @grid.each_with_index do |row, index_y|
      round_grid[index_y] = []
      row.each_with_index do |cell, index_x|
        neighbours = neighbours_for(index_x, index_y)
        if cell == '*'
          if [2,3].include?(neighbours)
            round_grid[index_y][index_x] = '*'
          else
            round_grid[index_y][index_x] = '.'
          end
        elsif cell == '.' 
          if neighbours == 3
            round_grid[index_y][index_x] = '*'
          else
            round_grid[index_y][index_x] = '.'
          end
        end
        # puts "[#{index_x+1}, #{index_y+1}] = #{neighbours} #{cell} - #{round_grid[index_y][index_x]}"
      end
    end
    @grid = round_grid
  end
  
  def neighbours_for(index_x, index_y)
    neighbours = 0
    (-1..1).each do |modifier_y|
      (-1..1).each do |modifier_x|
        val_y = index_y + modifier_y
        val_x = index_x + modifier_x
        next if modifier_x == 0 && modifier_y == 0
        if (0...@size_y).include?(val_y) && (0...@size_x).include?(val_x)
          if @grid[val_y][val_x] == '*'
            neighbours += 1
            return neighbours if neighbours > 3
          end
        end
      end
    end
    
    neighbours
  end
  
  def show_grid
    @grid.map{|row| row.join('')}
  end
end

game = GameOfLife.new(File.open(ARGV[0], "r").read)
time_start = Time.now
game.play(20)
puts "Time played = #{(Time.now - time_start).round(4)}s"
puts game.show_grid
