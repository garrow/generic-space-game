module Space
  class Shot < GameObject
    attr_accessor :x, :y, :speed

    def initialize(x, y, speed = 4)
      @x     = x
      @y     = y
      @speed = speed
    end

    def update
      @y -= speed
      destroy if @y < 0
    end

    def render(window)
      window.draw Ray::Polygon.circle([x, y], 2, colour)
    end

    def colour
      @colour ||= Ray::Color.new(255, 0, 0)
    end
  end
end
