module Space
  class Ship < GameObject
    def self.tilesheet_path
      File.join(File.dirname(__FILE__), '../../assets/space-shooter-redux/sheet.png')
    end

    attr_reader :y, :x, :gun_timer

    SIZE = 30
    CENTER = SIZE / 2

    IMAGE = begin
      Ray::Image.new tilesheet_path
    end

    def colour
      Ray::Color.new(255, 255, 255)
    end

    def initialize(bounds)
      @gun_timer = CooldownTimer.new
      @max_x     = bounds.x
      @x         = bounds.x / 2
      @y         = bounds.y - 20
      @sprite    = Ray::Sprite.new IMAGE
      # <SubTexture name="playerLife1_blue.png" x="482" y="358" width="33" height="26"/>
      @sprite.sub_rect = [482, 358, 32, 26]
      @size = @sprite.rect.size
      # binding.pry
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
      offset = @size / 2


      @sprite.x = @x - offset.x
      @sprite.y = @y - offset.y

      # @sprite.x = @x - CENTER
      # @sprite.y = @y - CENTER
    end

    def render(window)
      window.draw @sprite
    end
  end

end
