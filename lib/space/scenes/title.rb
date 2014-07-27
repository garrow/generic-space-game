module Space
  module Scenes
    class Title < Ray::Scene

      scene_name :title

      def register
        add_hook :quit, method(:exit!)
        on(:key_press, key(:q)) { exit! }
        on(:key_press, key(:space)) { push_scene(:invasion) }

      end


      def render(window)
        window.draw text "Press Space to Start", at: window.view.center
      end
    end
  end
end

