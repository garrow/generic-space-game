module Space
  class Bomb < Shot

    def initialize(x, y, speed = 2)
      super(x, y, speed)
    end

    def update
      @y += speed
      destroy if @y > 400
    end

    def colour
      @colour ||= Ray::Color.new(255, 255, 0)
    end
  end
end
