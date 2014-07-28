module Space
  class Enemy < GameObject

    def tilesheet_path
      File.join(File.dirname(__FILE__), '../../assets/space-shooter-redux/sheet.png')
    end
    attr_accessor :x, :y, :gun_timer
    attr_reader :size

# <SubTexture name="playerLife3_red.png" x="777" y="443" width="32" height="26"/>
    def initialize(x, y)
      @gun_timer = CooldownTimer.new(rand(2..4))
      @x         = x
      @y         = y

      @sprite = begin
        Ray::Sprite.new Ray::Image.new tilesheet_path
      end
      @sprite.sub_rect = [777, 443, 32, 26]
      @size = @sprite.rect.size
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

      offset = @size / 2

      @sprite.x = @x - offset.x
      @sprite.y = @y - offset.y

      window.draw @sprite
    end
  end
end

