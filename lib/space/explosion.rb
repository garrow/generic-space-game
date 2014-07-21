module Space
  class Explosion < GameObject

    attr_accessor :x, :y

    def initialize(x, y)
      @birth = Time.now
      @x     = x
      @y     = y
    end

    def update
      destroy if (Time.now - @birth) > 0.5
    end

    def age
      Time.now - @birth
    end

    def render(window)
      colour_age = age * 2
      colour     = Ray::Color.white

      size         = age * 50
      colour.alpha = 255 - (255 * colour_age)

      window.draw Ray::Polygon.circle([x, y], size, colour)
    end
  end
end
