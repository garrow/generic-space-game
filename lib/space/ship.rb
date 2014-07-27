module Space

  class Ship < GameObject

    attr_reader :y, :x, :gun_timer

    SIZE = 30
    CENTER = SIZE / 2

    IMAGE = begin
      image = Ray::Image.new [SIZE, SIZE]
      Ray::ImageTarget.new(image) do |target|
        target.draw Ray::Polygon.circle([CENTER, CENTER], CENTER, Ray::Color.new(255, 255, 255))
        target.update
      end
      image
    end

    def colour
      Ray::Color.new(255, 255, 255)
    end

    def initialize(bounds)
      @gun_timer = CooldownTimer.new
      @max_x     = bounds.x
      @x         = bounds.x / 2
      @y         = bounds.y - 20
      @sprite    = Ray::Sprite.new IMAGE
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

    def update
      @sprite.x = @x - CENTER
      @sprite.y = @y - CENTER
    end

    def render(window)
      window.draw @sprite
    end
  end

end
