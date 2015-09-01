class Presenter

  class << self
    attr_accessor :env
  end

  def self.insert_room(matrix)
    system('clear') if @env == 'show'
    self.draw_room(matrix)
    gets if @env == 'dev'
    sleep(0.3) if @env == 'show'
  end

  def self.draw_room(matrix)
    if @env == 'show' || @env == 'dev'
      puts matrix.map { |row| row.join }
    end
  end

  def self.put_delimiter
    puts '-' * 20 if @env == 'dev'
  end

  def self.inspect_ray(ray)
    puts ray.inspect if @env == 'dev'
  end

  def self.put_description
    if @env == 'show'
      puts "To cała ścieżka rozchodzenia się światła w tym pokoju.\n\n-\tJeśli chcesz obejrzeć ponownie wpisz: redo\n\t\ti potwierdź ENTER\n-\tAby zakończyć wpisz: exit\n\t\ti wciśnij ENTER\n-\tAby przejśc do następnego pokoju: wciśnij ENTER."
      decision = gets.chomp
      system('clear')
    end
    decision
  end
end