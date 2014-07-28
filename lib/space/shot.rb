module Space
  class Shot < GameObject

    def self.tilesheet_path
      File.join(File.dirname(__FILE__), '../../assets/space-shooter-redux/sheet.png')
    end

    IMAGE = Ray::Image.new tilesheet_path

    attr_accessor :x, :y, :speed

    def initialize(x, y, speed = 4)
      @x     = x
      @y     = y
      @speed = speed
      @sprite = Ray::Sprite.new(IMAGE, zoom: [0.5, 0.25])
      # <SubTexture name="laserBlue01.png" x="856" y="421" width="9" height="54"/>
      @sprite.sub_rect = [856, 421, 9, 54]
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
