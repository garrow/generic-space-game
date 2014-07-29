module Space
  module Scenes
    class Title < Ray::Scene

      scene_name :title

      FONT_PATH = File.join(File.dirname(__FILE__), '../../../assets/kenvector_future_thin.ttf')

      attr_writer :message_text
      attr_reader :starfield

      def setup
        @starfield = Starfield.new(window.size)
      end

      def register
        add_hook :quit, method(:exit!)
        on(:key_press, key(:q)) { exit! }
        on(:key_press, key(:space)) { push_scene(:invasion) }

        always do
          starfield.update
        end
      end

      def message_text
        @message_text ||= begin
          text("Press Space to Start", font: FONT_PATH, size: 20).tap do |t|
            # Center the text on screen.
            coords = window.view.center - (t.rect.size / 2)
            t.x = coords.x
            t.y = coords.y
          end
        end
      end

      def render(window)
        starfield.draw(window)

        window.draw message_text
      end
    end
  end
end
