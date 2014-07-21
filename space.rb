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
  end
end


class Game < Ray::Game
  def initialize
    super "Space"

    SpaceScene.bind(self)

    scenes << :space
  end
end

class SpaceScene < Ray::Scene

  scene_name :space

  attr_reader :object_types

  def setup
    @object_types = [Shot, Ship, Enemy, Explosion, Bomb]
    Ship.create(window.size)
    10.times do
      Enemy.create(rand(window.size.x), rand(window.size.y / 2))
    end
  end

  def register
    add_hook :quit, method(:exit!)

    always do
      update
    end
  end

  def update
    exit! if holding? key(:q)

    if holding? key(:left)
      Ship.get.left
    end
    if holding? key(:right)
      Ship.get.right
    end
    if holding? key(:space)
      Ship.get.shoot
    end

    object_types.each do |obj_class|
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
    origin = 0
    object_types.each do |obj_class|
      obj_class.all.each do |obj_instance|
        window.draw(text "#{obj_class} #{obj_instance.x}:#{obj_instance.y} ", :at => [0, origin])
        origin += 10
        obj_instance.render(window)
      end
    end
  end
end

class Ship < GameObject

  attr_reader :y, :x, :gun_timer

  def colour
    Ray::Color.new(255, 255, 255)
  end

  def initialize(bounds)
    @gun_timer = CooldownTimer.new
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

  def shoot
    if gun_timer.ready?
      gun_timer.trigger
      Shot.create(x, y)
    end
  end

  def render(window)
    window.draw Ray::Polygon.circle([x, y], 15, colour)
  end
end

class CooldownTimer

  attr_reader :last_trigger, :cooldown

  def initialize(cooldown = 0.1)
    @cooldown = cooldown
    @last_trigger = Time.now
  end

  def ready?
    Time.now - last_trigger > cooldown
  end

  def trigger
    return unless ready?
    @last_trigger = Time.now
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
    window.draw Ray::Polygon.circle([x,y], 2, colour)
  end

  def colour
    @colour ||= Ray::Color.new(255, 0, 0)
  end
end

class Bomb < Shot

  def initialize(x,y, speed = 2)
    super(x,y,speed)
  end

  def update
    @y += speed
    destroy if @y > 400
  end

  def colour
    @colour ||= Ray::Color.new(255, 255, 0)
  end
end

class Enemy < GameObject

  attr_accessor :x, :y, :gun_timer

  def initialize(x,y)
    @gun_timer = CooldownTimer.new(2)
    @x = x
    @y = y
  end

  def shoot
    if gun_timer.ready?
      gun_timer.trigger
      Bomb.create(x, y)
    end
  end

  def update
    shoot
    @x = @x + [-2, 2].sample
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
