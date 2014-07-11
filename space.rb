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

    [Shot, Ship, Enemy, Explosion].each do |obj_class|
      obj_class.all.each &:update
    end

    Shot.all.each do |shot|
      Enemy.all.each do |enemy|
        x = shot.x - enemy.x
        y = shot.y - enemy.y
        if x.abs < 10 && y.abs < 10
          enemy.destroy
          shot.destroy
          Explosion.create(shot.x, shot.y)
        end
      end
    end

  end

  def render(window)
    window.clear Ray::Color.new(50, 50, 60)

    colour =  Ray::Color.new(255, 255, 255)

    [Shot, Ship, Enemy, Explosion].each do |obj_class|
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
    @x = @x + [-5, 5].sample
    @y = @y + 0.5
  end

  def render(window)
    colour = Ray::Color.new(0, 255, 0)
    width = 10

    points = [x, y, 10, 10]

    drawable =  Ray::Polygon.rectangle(points, colour)

    window.draw  drawable
  end
end


class Explosion < GameObject

  attr_accessor :x, :y

  def initialize(x,y)
    @birth = Time.now
    @x = x
    @y = y
  end

  def update
    destroy if (Time.now - @birth) > 0.5
  end

  def age
    Time.now - @birth
  end

  def render(window)
    colour_age = age * 2
    colour = Ray::Color.white

    size = age * 50
    colour.alpha = 255 - (255 * colour_age)

    window.draw Ray::Polygon.circle([x,y], size , colour)
  end
end


game = Game.new

game.run
