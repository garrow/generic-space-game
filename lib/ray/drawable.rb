module Ray
  class Drawable
    def center_on(point)
      self.pos = point - (self.rect.size / 2)
      self
    end
  end
end
