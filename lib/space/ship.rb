module Space
  class Ship < GameObject

    attr_reader :y, :x, :gun_timer

    def initialize(bounds)
      @gun_timer = CooldownTimer.new(0.3)
      @max_x     = bounds.x
      @x         = bounds.x / 2
      @y         = bounds.y - 20
      @sprite    = SpriteLoader.build.sprite('playerLife1_blue.png')
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
      offset = @sprite.rect.size / 2

      @sprite.x = @x - offset.x
      @sprite.y = @y - offset.y
    end

    def render(window)
      window.draw @sprite
    end
  end
end
