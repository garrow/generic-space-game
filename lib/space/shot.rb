module Space
  class Shot < GameObject

    attr_accessor :x, :y, :speed

    def initialize(x, y, speed = 4)
      @x      = x
      @y      = y
      @speed  = speed
      @sprite = SpriteLoader.build.sprite('laserBlue01.png')
      @sprite.zoom = [0.5, 0.25]
    end

    def update
      @y -= speed
      destroy if @y < 0
    end

    def render(window)
      @sprite.x = @x
      @sprite.y = @y
      window.draw @sprite
    end
  end
end
