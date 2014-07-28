module Space
  module Scenes
    class Title < Ray::Scene

      scene_name :title

      def setup
        @starfield = Starfield.new(window.size)
      end

      def register
        add_hook :quit, method(:exit!)
        on(:key_press, key(:q)) { exit! }
        on(:key_press, key(:space)) { push_scene(:invasion) }

        always do
          @starfield.update
        end
      end

     def render(window)
        @starfield.draw(window)
        window.draw text "Press Space to Start", at: window.view.center
      end
    end
  end
end

