module Space
  class Enemy < GameObject


    attr_accessor :x, :y, :gun_timer

    def initialize(x, y)
      @gun_timer = CooldownTimer.new(3)
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
      @sprite ||= begin
        image = Ray::Image.new [10, 10]
        Ray::ImageTarget.new(image) do |target|
          target.draw Ray::Polygon.rectangle([0,0,10,10], Ray::Color.new(255, 0, 0))
          target.update
        end
        Ray::Sprite.new image
      end

      @sprite.x = @x
      @sprite.y = @y

      window.draw @sprite
    end
  end
end

