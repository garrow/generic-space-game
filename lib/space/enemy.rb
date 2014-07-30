module Space
  class Enemy < GameObject

    attr_accessor :x, :y, :gun_timer
    attr_reader :bounds

    def initialize(x, y, bounds)
      @gun_timer = CooldownTimer.new(rand(2..4))
      @x         = x
      @y         = y
      @bounds    = bounds
      @direction = [:+, :-].sample
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

    def y_speed
      rand(4)
    end

    def update
      shoot
      @x = (@x.send(@direction, y_speed)) % bounds.x
      @y = (@y + 0.5) % bounds.y
    end

    def render(window)
      offset = size / 2

      @sprite.x = @x - offset.x
      @sprite.y = @y - offset.y

      window.draw @sprite
    end
  end
end

