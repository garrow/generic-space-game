require 'ray'
require 'pry'

class GameObject
  def update
  end

  def render(window)
  end

  def destroy
    self.class.all.delete(self)
  end

  class << self
    def all
      @collection ||= []
    end

    def get(index = 0)
      @collection[index]
    end

    def create(*args)
      all << new(*args)
      all.last
    end

    def descendants
      @cache ||= begin
        ObjectSpace.each_object(Class).select do |klass|
          klass < self
        end
      end
    end
  end
end


class Game < Ray::Game
  def initialize
    super "Space"

    SpaceScene.bind(self)

    scenes << :cool
  end
end

class SpaceScene < Ray::Scene

  scene_name :cool

  def setup
    Ship.create(window.size)

    10.times do
      Enemy.create(rand(window.size.x), rand(window.size.y))
    end
  end

  def register
    add_hook :quit, method(:exit!)

    always do
      update
    end
  end

  def update
    if holding? key(:left)
      Ship.get.left
    end
    if holding? key(:right)
      Ship.get.right
    end

    if holding? key(:space)
      Ship.get.shoot
    end

    GameObject.descendants.each do |obj_class|
      obj_class.all.each &:update
    end
  end

  def render(window)
    window.clear Ray::Color.new(50, 50, 60)

    colour =  Ray::Color.new(255, 255, 255)

    GameObject.descendants.each do |obj_class|
      obj_class.all.each do |obj_instance|
        obj_instance.render(window)
      end
    end
  end
end

class Ship < GameObject

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

  def shoot
    return unless gun_cooled?

    @last_shot_at = Time.now
    Shot.create(x, y)
  end

  def render(window)
    window.draw Ray::Polygon.circle([x, y], 4, colour)
  end
end

class Shot < GameObject
  attr_accessor :x, :y, :speed

  def initialize(x, y, speed = 4)
    @x = x
    @y = y
    @speed = speed
  end

  def update
    @y -= speed
    destroy if @y < 0
  end

  def render(window)
    colour = Ray::Color.new(255, 0, 0)
    window.draw Ray::Polygon.circle([x,y], 2, colour)
  end
end

class Enemy < GameObject

  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def update
    @y = @y + 1
  end

  def render(window)
    colour = Ray::Color.new(0, 255, 0)
    width = 10

    left_point = [x, y]
    right_point = [x, y + 5]
    drawable =  Ray::Polygon.line(left_point, right_point, width, colour)

    window.draw  drawable
  end
end

game = Game.new

game.run
