class Presenter
  def self.draw_room(matrix)
    system('clear') if $env == 'show'
    if $env == 'show' || $env == 'dev'
      puts matrix.map{ |row| row.join }
    end
    gets if $env == 'dev'
    sleep(0.3)  if $env == 'show'
  end
  def self.put_delimiter
    puts '-' * 20 if $env == 'dev'
  end
  def self.inspect_ray(ray)
    puts ray.inspect if $env == 'dev'
  end
end