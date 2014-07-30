module Ray
  class Drawable
    def center_on(point)
      offset_coordinates = point - (self.rect.size / 2)
      self.pos = offset_coordinates
    end
  end
end
