module Space

  class Starfield

    def initialize(bounds)
      @planes = [
        Starplane.new(bounds, speed: 0.0,  density: 100),
        Starplane.new(bounds, speed: 0.25, density: 150),
        Starplane.new(bounds, speed: 0.50, density: 100),
        Starplane.new(bounds, speed: 0.75, density:  50),
        Starplane.new(bounds, speed: 1,    density:  20),
        Starplane.new(bounds, speed: 2,    density:  10),
        Starplane.new(bounds, speed: 4,    density:   4),
      ]
    end

    def update
      @planes.map &:update
    end

    def draw(window)
      @planes.each { |field| field.draw(window) }
    end

    class Starplane
      def self.star(color)
        image = Ray::Image.new [1, 1]
        Ray::ImageTarget.new(image) do |target|
          target.draw Ray::Polygon.circle([1,1], 1, color)
          target.update
        end
        image
      end

      WHITE = star(Ray::Color.new(255, 255, 255))
      RED   = star(Ray::Color.new(255, 240, 240))
      BLUE  = star(Ray::Color.new(240, 240, 255))
      GREEN = star(Ray::Color.new(240, 255, 240))
      STAR_COLOURS = [WHITE, RED, BLUE, GREEN]

      attr_accessor :bounds
      attr_reader :speed, :density

      def initialize(bounds, speed: 0.5, density: 100)
        @bounds = bounds
        @speed = speed
        @density = density
      end

      def random_star
        STAR_COLOURS.sample
      end

      def stars
        @stars ||= begin
          max_x = bounds.x
          max_y = bounds.y
          density.times.collect { Ray::Sprite.new(random_star, at: [rand(max_x), rand(max_y)]) }
        end
      end

      def draw(window)
        stars.each do |star|
          window.draw star
        end
      end

      def update
        max_x = bounds.x
        max_y = bounds.y
        stars.each do |star|
          star.y += speed
          if star.y > max_y
            star.y %= max_y
            star.x = rand(max_x)
          end
        end
      end
    end
  end
end
