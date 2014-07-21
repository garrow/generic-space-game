module Space
  class Enemy < GameObject


    attr_accessor :x, :y, :gun_timer

    def initialize(x, y)
      @gun_timer = CooldownTimer.new(2)
      @x         = x
      @y         = y
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
      width  = 10

      points = [x, y, 10, 10]

      drawable = Ray::Polygon.rectangle(points, colour)

      window.draw drawable
    end
  end
end

