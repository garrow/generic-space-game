module Space
  class Enemy < GameObject

    attr_accessor :x, :y, :gun_timer

    def initialize(x, y)
      @gun_timer = CooldownTimer.new(rand(2..4))
      @x         = x
      @y         = y
      @sprite    = SpriteLoader.build.sprite('playerLife3_red.png')
    end

    def size
      @sprite.rect.size
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
      offset = size / 2

      @sprite.x = @x - offset.x
      @sprite.y = @y - offset.y

      window.draw @sprite
    end
  end
end

