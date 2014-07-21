module Space
  class GameObject
    def update
    end

    def render(window)
    end

    def destroy
      self.class.all.delete(self)
    end

    class << self
      def all
        @collection ||= []
      end

      def get(index = 0)
        @collection[index]
      end

      def create(*args)
        all << new(*args)
        all.last
      end
    end
  end
end
