module Space

  class Ship < GameObject

    attr_reader :y, :x, :gun_timer

    IMAGE = begin
      image = Ray::Image.new [30, 30]
      Ray::ImageTarget.new(image) do |target|
        target.draw Ray::Polygon.circle([15, 15], 15, Ray::Color.new(255, 255, 255))
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
      @sprite.x = @x
      @sprite.y = @y
    end

    def render(window)
      window.draw @sprite
    end
  end

end
