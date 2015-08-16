class String
  
  def to_matrix( row_length = 1 )
    scan(/.{#{row_length}}/).to_a
  end
  
  def is_ray?
    self == '/' || self == '\\'
  end
  
  def is_pillar?
    self == 'o'
  end
  
  def is_space?
    self == ' '
  end
  
  def is_prism?
    self == '*'
  end
  
  def is_wall?
    self == '#'
  end
  
  def is_crossing?
    self == 'X'
  end
  
  def is_perpendicular_to?( ray_sign )
    self == '/' && ray_sign == '\\' || self == '\\' && ray_sign == '/'
  end
end

class Array
  
  def is_corner?
    [0, 9].repeated_permutation(2).to_a.include? self
  end
  
  def out_of_borders?
    [-1, 10].include?(self[0]) || [-1, 10].include?(self[1])
  end
  
  def double_join
    map(&:join).join
  end
end

class LineSerializer
  
  def initialize(line)
    @matrix = []
    @line = line
  end
  
  def serialize
    @matrix = @line.to_matrix( 10 )
    @matrix.map{|row| row.split('')}
  end
end

class Ray
  ROTATIONS = {
    45 => {sign: '/', vector: {row: -1, column: 1}},
    135 => {sign: '\\', vector: {row: 1, column: 1}},
    225 => {sign: '/', vector: {row: 1, column: -1}},
    315 => {sign: '\\', vector: {row: -1, column: -1}}
  }
  ROTATION_REFLECTIONS = {
    top: {
      315 => 225,
      45 => 135
    },
    bottom: {
      225 => 315,
      135 => 45
    },
    right: {
      45 => 315,
      135 => 225
    },
    left: {
      315 => 45,
      225 => 135
    }
  }
  
  attr_accessor :row_pos, :column_pos, :length
  attr_reader :rotation
  def initialize( row_pos, column_pos, rotation, length = 1 )
    @row_pos = row_pos
    @column_pos = column_pos
    @rotation = rotation
    @length = length
  end
  
  def self.get_rotation_for( row, column, sign )
    if sign == '/'
      return 45 if row == 9 || column == 0
      return 225 if row == 0 || column == 9
    elsif sign == '\\'
      return  135 if row == 0 || column == 0
      return 315 if row == 9 || column == 9
    end
  end
  
  def new_splits
    rotations = split_rotations.map do |rotation|
      Ray.new( *position, rotation, length )
    end
    return rotations
  end
  
  def split_rotations
    [(rotation - 90) % 360, (rotation + 90) % 360]
  end
  
  def sign
    ROTATIONS[rotation][:sign]
  end
  
  def vector
    ROTATIONS[rotation][:vector]
  end
  
  def next_position
    {
      row: @row_pos + vector[:row],
      column: @column_pos + vector[:column]
    }
  end
  
  def position
    [@row_pos, @column_pos]
  end
  
  def move( opts = {} )
    @row_pos, @column_pos = next_position.values
    @length += 1 unless opts[:prism]
  end
  
  def reflect_position
    @row_pos = next_position[:row] if [0, 9].include?(next_position[:row])
    @column_pos = next_position[:column] if [0, 9].include?(next_position[:column])
    @rotation = ROTATION_REFLECTIONS[reflection_side][@rotation]
  end
  
  def reflection_side
    case
    when next_position[:column] == -1 then :left
    when next_position[:column] == 10 then :right
    when next_position[:row] == -1 then :top
    when next_position[:row] == 10 then :bottom
    end
  end
end

$env = 'show'

class LightDistributor
  def initialize(matrix)
    @matrix = matrix
    @rays = []
  end
  
  def to_s
    distribute
    @matrix.double_join if $env == 'development'
  end
  
  
  
  def distribute
    find_and_create_rays
    until @rays.empty?
      move( @rays )
      
      if $env == 'show' || $env == 'development'
        system('clear') if $env == 'show'
        puts @matrix.map{ |row| row.join }
        sleep 1
      end
    end
  end
  
  private
  
  def move( rays )
    @rays_to_move_again = []
    @rays_new = []
    @rays_to_delete = []
    
    rays.each do |ray|
      next_position = ray.next_position.values
      next if ray_out_of_borders?( ray, next_position )
      next_element = get_element_in( *next_position )
      next if ray_stops?(ray, next_position, next_element)
      step(ray, next_element)
    end
    
    @rays -= @rays_to_delete
    @rays += @rays_new
    
    puts '-' * 20 if $env == 'development' && !@rays_to_move_again.empty?
    move(@rays_to_move_again) unless @rays_to_move_again.empty?
  end
    
  def step(ray, next_element)
    case 
    when next_element.is_space?
      ray.move
      set_element_in( *ray.position, ray.sign )
    when next_element.is_perpendicular_to?( ray.sign )
      ray.move
      set_element_in( *ray.position, 'X' )
    when next_element.is_crossing? || next_element.is_ray?
      ray.move
    when next_element.is_prism?
      ray.move( prism: true )
      create_and_allocate_splits_of( ray )
    when next_element.is_wall?
      ray.reflect_position
      @rays_to_move_again << ray
    end
    puts ray.inspect if $env == 'development'
  end
  
  def ray_stops?(ray, next_position, next_element)
    if ray.length > 20 || next_position.is_corner? || next_element.is_pillar?
      @rays_to_delete << ray
      return true
    end
  end
  
  def ray_out_of_borders?(ray, next_position)
    if next_position.out_of_borders?
      @rays_to_delete << ray
      return true
    end
  end
  
  def get_element_in( row, column )
    @matrix[row][column]
  end
  
  def set_element_in ( row, column, sign )
    @matrix[row][column] = sign
  end
  
  def find_and_create_rays
    @rays = []
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        if item.is_ray?
          rotation = Ray.get_rotation_for( row_index, column_index, item)
          @rays << Ray.new(row_index, column_index, rotation)
        end
      end
    end
  end
  
  def create_and_allocate_splits_of( ray )
    splits = ray.new_splits
    @rays_new += splits
    @rays_to_move_again += splits << ray
  end
end

class Runner
  LINES = [
    '###########        ##  o  o  ##    o o ## o   *o ## o o    ## * * *o ##        ##        ####/######',
    '###########        ##    *   ## *      ##    *   ##   *    ##     ** ##     ** ##        ####/######',
    '###########        ##    * o ##  o     #/    o   ## o *    ##        ##        ##        ###########',
    '###########        ##      o ## o o  o ## o oo*  #/  o  o  ## **   o ##        ##        ###########',
    '###########        ##      o ##   o*   ## *    o ##        ##  *     ##  *     ##        ###\#######',
    '###########        ##    o   ##  o     ##        ##        ##   *    ## o o *  ##        ####\######',
    '#####/#####        ##        ##        ##  *     ##        ##      o ##   o    ##        ###########',
    '###########        ##   *    ## o o  o ##  o     ##    o   ##    o   ##     o  ##        ###\#######',
    '###########        ##  *     ##   o    ## *      ##  *     ## *   *  ##      * ##        #########/#',
    '###########        ##   *    ##  *   o ##   *  o ##  o     ##  o*o*  ## oo  o  \#        ###########',
    '###########        ##     *  ##        ##  o   * ##   * *  ##      * ##    *   ##        ######\####',
    '######\####        ##        ##     *  ##        ##        ##  o     ##        ##        ###########',
    '######/####        ##        ##  o o   ##   o    ##        ##        ##     *  ##        ###########',
    '###########        ##        ##        ##  *   o \#   *  o ##  o     ##     *  ##        ###########',
    '###########        ##        ## *   ** ##   *    ##  o* o  ##  o     ##     *  ##        #######\###',
    '###########        ##  **    ##  o     ##   o *  ##   *    ##      o ## o o    ##        ###/#######',
    '###########        ##  o     #\        ##    *   ##  o     ##    *   ## o  **  ##        ###########',
    '###########        ## o o    ## o  o   ## o      ##        ##        ##     o  ##        ###/#######',
    '###########        ## *      ##    *   ##     o  ##        ##    **  /#        ##        ###########',
    '########\##        ##  *     ##    o   ##        ##   *    ##   *    ##   o *  ##        ###########',
    '##/########        ##   o    ##    o   ##  oo    ##    o   ##        ## *      ##        ###########',
    '###########        ##   o  * ##        ##        ##    o * ##    *   ##   o    #\        ###########',
    '######\####        ##        ##  o o   ## **     ##        ##   o *  ##    o   ##        ###########',
    '###########        ##     o  ##      o ##    o   ## o  o   ##   o    ##        ##        #########/#',
    '###########        ##      * ## *      ##        ##      * ##        ## o      ##        ########/##',
    '##\########        ##   o *  ## oo     ##        ##    *oo ##  *     ##        ##        ###########',
    '###########        ##  o*    ##   o    #\    o   ##        ##   o    ##    o   ##        ###########',
    '#####/#####        ##        ## *    * ##    o   ## o   *  ##  *     ##        ##        ###########',
    '###########        ##        ## *   *  ##        #\    o * ##        ##    o   ##        ###########',
    '###########        ##  o  *  #\ o   *  ##        ##        ##   **o  ##      o ##        ###########',
    '###########        ## o  o   ##        ##   o*   ##        ##     *o #\  o     ##        ###########',
    '###########        ##    o   ##        ##   *    ## o*o    ##   o    ##  oo*** ##        ######/####',
    '###########        ##    o   ##   *o   ## o o    ## ooo    ##        ##    *   ##        ###\#######',
    '##/########        ##        ##        ##  o     ## *  oo  ##   **   ##    *   ##        ###########',
    '###########        ##        ##    o   /# o   o  ##        ##     ** ##  o*    ##        ###########',
    '###########        ##     *  ##     o  ##        ##  *     ##   o*   /#     *  ##        ###########',
    '###########        ##        ##    oo  ##        #\ o   o  ##  *     ##        ##        ###########',
    '#####/#####        ##   o *  ##        ##     o  ##     *  ##        ##   o    ##        ###########',
    '###########        ##        ##        ##    *   ##    o   ##  *     /#  o     ##        ###########',
    '###########        ##        ##        ##   *    ##        ##     *  ##        ##        #####/#####',
    '#####\#####        ##  o     ##   *    ##        ##        ##  *     ## * *  o ##        ###########',
    '###########        ## o      ##     *  ## *   *  #\        ##    * * ## * *    ##        ###########',
    '#####\#####        ##        ##        ##        ##        ##        ##    *   ##        ###########'
    ]
    
    def self.run
      LINES.each do |line|
        LightDistributor.new(LineSerializer.new(line.strip).serialize).distribute
        puts "To cała ścieżka rozchodzenia się światła w tym pokoju.\n\n-\tJeśli chcesz obejrzeć ponownie wpisz: redo\n\t\ti potwierdź ENTER\n-\tAby przejśc do następnego pokoju: wciśnij ENTER."
        decision = gets.chomp
        system('clear')
        redo if decision == 'redo'
      end
    end
    
end

Runner.run