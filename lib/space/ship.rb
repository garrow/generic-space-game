module Space

  class Ship < GameObject

    attr_reader :y, :x, :gun_timer

    def colour
      Ray::Color.new(255, 255, 255)
    end

    def initialize(bounds)
      @gun_timer = CooldownTimer.new
      @max_x     = bounds.x
      @x         = bounds.x / 2
      @y         = bounds.y - 20
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

end
