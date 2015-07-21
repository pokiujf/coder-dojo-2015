class GameOfLife
  
  def initialize(grid)
    grid.split!("\n")
  end
  
  def play(rounds)
    (1..rounds).each do |round_number|
      play_round
      
    end
  end
  
  def play_round
    
  end
  
  def show_grid
    
  end
end


starting_grid = File.open(ARGV[0], "r").read
game = GameOfLife.new(starting_grid)

