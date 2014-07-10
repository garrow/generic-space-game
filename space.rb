require 'ray'
require 'pry'

class Game < Ray::Game
  def initialize
    super "SpaceInvaders"

    SpaceScene.bind(self)

    scenes << :cool
  end
end

class SpaceScene < Ray::Scene

  scene_name :cool

  attr_accessor :ship
  attr_accessor :shots

  def setup
    @ship = Ship.new(window.size)
    @shots = []
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
      puts 'SPACE'
      @ship.shoot(self)
    end

    shots.each do |shot| 
      shot.update
      shots.delete(shot) if shot.y < 0
    end
  end

  def render(window)
    colour =  Ray::Color.new(255, 255, 255)
    shots.each do |shot|
      #puts shot.inspect

      shot.draw(window)
    end

    window.draw @ship.draw_as
  end
end

class Ship

  attr_accessor :x
  attr_reader :y



  def colour
    Ray::Color.new(255, 255, 255)
  end

  def initialize(window_dimensions)
    @x = window_dimensions.to_a[0] / 2
    @y = window_dimensions.to_a[1] - 20
  end

  def speed
    10
  end

  def left
    @x -= speed
  end

  def right
    @x += speed
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


game = Game.new

game.run
