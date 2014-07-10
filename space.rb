require 'ray'
require 'pry'

class Game < Ray::Game
  def initialize
    super "Gong"

    SpaceScene.bind(self)

    scenes << :cool
  end
end

class SpaceScene < Ray::Scene

  scene_name :cool

  attr_accessor :ship

  def setup
    @ship = Ship.new(window.size)
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
  end

  def render(window)
    colour =  Ray::Color.new(255, 255, 255)
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

  def draw_as
    width = 10

    left_point = [x, y]
    right_point = [x, y + 5]

    Ray::Polygon.line(left_point, right_point, width, colour)
  end

end

game = Game.new

game.run
