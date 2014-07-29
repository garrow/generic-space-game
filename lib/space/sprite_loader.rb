require 'rexml/document'

require 'delegate'

module Space
  class TextureAtlas < SimpleDelegator
    def initialize(atlas_file_path)
      textures = {}

      REXML::Document.new(File.read( atlas_file_path )).elements.each('TextureAtlas/SubTexture') do |tex|
        name = tex.attribute('name').value
        values = %w{x y width height}.collect { |attr| tex.attribute(attr).value.to_i }
        textures[name] = SubTexture.new(name, *values)
      end

      __setobj__(textures)
    end
  end

  SubTexture = Struct.new(:name, :x, :y, :width, :height) do
    def bounding_box
      [x, y, width, height]
    end
  end

  class SpriteLoader

    # Lazy, shitty singletonish.
    def self.build
      @instance ||= begin
        p = File.join(File.dirname(__FILE__), '../../assets/space-shooter-redux/')

        sheet_path = File.join(p, 'sheet.png')
        atlas_path = File.join(p, 'sheet.xml')
        new(sheet_path, atlas_path)
      end
    end

    attr_reader :sheet_path, :atlas_path

    def initialize(sheet_path, atlas_path)
      @sheet_path = sheet_path
      @atlas_path = atlas_path
    end

    def sprite(image_name)
      Ray::Sprite.new(image, rect: position_on_sheet(image_name))
    end

    private def image
      @image ||= Ray::Image.new(sheet_path)
    end

    private def atlas
      @atlas ||= TextureAtlas.new(atlas_path)
    end

    private def position_on_sheet(image_name)
      atlas[image_name].bounding_box
    end
  end
end
