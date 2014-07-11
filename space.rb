require 'ray'
require 'pry'

class Game < Ray::Game
  def initialize
    super "Space"

    SpaceScene.bind(self)

    scenes << :cool
  end
end

class SpaceScene < Ray::Scene

  scene_name :cool

  attr_accessor :ship, :shots, :enemies

  def setup
    @ship = Ship.new(window.size)
    @shots = []
    @enemy_formation = Formation.new(window.size, 100)
    @enemies = @enemy_formation.ships
  end

  def register
    add_hook :quit, method(:exit!)

    always do
      update
    end
  end

  def update
    if holding? key(:left)
      @ship.left
    end
    if holding? key(:right)
      @ship.right
    end

    if holding? key(:space)
      #puts 'SPACE'
      @ship.shoot(self)
    end

    shots.each do |shot|
      shot.update
      shots.delete(shot) if shot.y < 0
    end

    @enemy_formation.update

    enemies.each do |enemy|
      enemy.update
      shots.each do |shot|
        x = enemy.x - shot.x
        y = enemy.y - shot.y
        if x.abs < 10 && y.abs < 5
          enemies.delete(enemy)
          shots.delete(shot)
        end
      end
    end
  end

  def render(window)
    window.clear Ray::Color.new(50, 50, 60)

    colour =  Ray::Color.new(255, 255, 255)
    shots.each do |shot|
      #puts shot.inspect

      shot.draw(window)
    end


    enemies.each do |enemy|
      #puts enemy.inspect

      enemy.draw(window)
    end

    window.draw @ship.draw_as
  end
end

class Ship

  attr_reader :y, :x

  def colour
    Ray::Color.new(255, 255, 255)
  end

  def initialize(bounds)
    @max_x = bounds.x
    @x = bounds.x / 2
    @y = bounds.y - 20
  end

  def speed
    10
  end

  def x=(v)
    @x = v % @max_x
  end

  def left
    self.x -= speed
  end

  def right
    self.x += speed
  end

  def last_shot_at
    @last_shot_at ||= Time.now
  end

  def gun_cooled?
    Time.now - last_shot_at > 0.1
  end

  def shoot(scene)
    return unless gun_cooled?

    @last_shot_at = Time.now
    scene.shots << Shot.new(x, y)
  end

  def draw_as
    width = 10

    left_point = [x, y]
    right_point = [x, y + 5]

    Ray::Polygon.line(left_point, right_point, width, colour)
  end
end

class Shot
  attr_accessor :x, :y, :speed

  def initialize(x, y, speed = 4)
    @x = x
    @y = y
    @speed = speed
  end

  def update
    @y -= speed
  end

  def draw(window)
    colour = Ray::Color.new(255, 0, 0)
    bottom_point = [x , y - 5]
    top_point = [x, y]
    window.draw Ray::Polygon.line(bottom_point, top_point, 3, colour)
  end
end

class Enemy

  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def update
  end

  def draw(window)
    colour = Ray::Color.new(0, 255, 0)
    width = 10

    left_point = [x, y]
    right_point = [x, y + 5]
    drawable =  Ray::Polygon.line(left_point, right_point, width, colour)

    window.draw  drawable
  end
end

class Formation
  attr_reader :ships

  def initialize(dimensions, size = 20)
    @orders = []

    x = dimensions.x
    y = dimensions.y / 2

    @ships = size.times.collect do
      Enemy.new(any(x), any(y))
    end

    #@ships = [Enemy.new(dimensions)]
  end


  def any(v)
    rand(0..v)
  end

  def aggressiveness
    0.75
  end

  def moved_at
    @moved_at ||= moved!
  end

  def moved!
    @moved_at = Time.now
  end

  def time_to_move?
   Time.now - moved_at > aggressiveness
  end

  def update
    if time_to_move?
      @ships.each do |ship|
        ship.y += any(5)
        ship.x += rand(-5..5)
      end
      moved!
    end
  end

  def last_moved_at
    @last_shot_at ||= Time.now
  end

  def gun_cooled?
    Time.now - last_shot_at > 0.1
  end



end

game = Game.new

game.run
