module Space
  module Scenes
    class Invasion < Ray::Scene

      scene_name :invasion

      FONT_PATH = File.join(File.dirname(__FILE__), '../../../assets/kenvector_future_thin.ttf')

      attr_reader :object_types

      def setup
        @object_types = [Shot, Ship, Enemy, Explosion, Bomb]
        @score = 0
        @starfield = Starfield.new(window.size)

        @lives = 3

        Ship.create(window.size)
        10.times do
          Enemy.create(rand(window.size.x), rand(window.size.y / 4))
        end
      end

      def register
        add_hook :quit, method(:exit!)

        always do
          update
        end
      end

      def update
        exit! if holding? key(:q)

        if holding? key(:left)
          Ship.get.left
        end
        if holding? key(:right)
          Ship.get.right
        end
        if holding? key(:space)
          Ship.get.shoot
        end

        @starfield.update

        object_types.each do |obj_class|
          obj_class.all.each &:update
        end

        Shot.all.each do |shot|
          Enemy.all.each do |enemy|
            x = shot.x - enemy.x
            y = shot.y - enemy.y
            bounding = enemy.size / 2
            if x.abs < bounding.x && y.abs < bounding.y
              # binding.pry
              enemy.destroy
              shot.destroy
              @score += 1
              Explosion.create(shot.x, shot.y)
            end
          end
        end

        ship = Ship.get
        Bomb.all.each do |bomb|
          x = bomb.x - ship.x
          y = bomb.y - ship.y
          if x.abs < 15 && y.abs < 15
            @lives =  @lives - 1

            Explosion.create(bomb.x, bomb.y)
            bomb.destroy

            if @lives < 1
              exit
            end
          end
        end
      end

      def clean_up
        object_types.each do |ot|
          ot.all.map &:destroy
        end
      end

      private def default_text(string, opts = {})
        text(string, opts.merge!(font: FONT_PATH, size: 20))
      end

      def render(win)
        @starfield.draw(win)

        object_types.each do |obj_class|
          obj_class.all.each do |obj_instance|
            obj_instance.render(win)
          end
        end

        if @game_over
          game_over_text = default_text("Game Over\n  Score: #{@score}").tap do |t|
            t.center_on(win.view.center)
          end
          win.draw game_over_text
        else
          win.draw default_text "Score: #{@score}", at: [10,10]
          win.draw default_text "Lives: #{@lives}", at: [10,win.view.size.y - 30]
        end
      end
    end
  end
end

