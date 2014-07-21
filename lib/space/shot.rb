module Space
  class Shot < GameObject

    IMAGE = begin
          image = Ray::Image.new [4, 4]
          Ray::ImageTarget.new(image) do |target|
            target.draw Ray::Polygon.circle([2,2], 2, Ray::Color.new(255, 0, 0))
            target.update
          end
          image
        end

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
      @sprite ||= Ray::Sprite.new(IMAGE)

      @sprite.x = @x
      @sprite.y = @y

      window.draw @sprite
    end
  end
end
