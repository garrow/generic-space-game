module Space
  module Scenes
    class Invasion < Ray::Scene

      scene_name :invasion

      attr_reader :object_types

      def setup
        @object_types = [Shot, Ship, Enemy, Explosion, Bomb]
        @score = 0
        @starfield = Starfield.new(window.size)

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
            if x.abs < 10 && y.abs < 10
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
            game_over(bomb)


            #   bomb.destroy
            #   ship.destroy

          end
        end
      end

      def clean_up
        object_types.each do |ot|
          ot.all.map &:destroy
        end
      end

      def game_over(bomb)

        Explosion.create(bomb.x, bomb.y)
        exit
      end

      def render(win)
        # @clear_colour ||= Ray::Color.new(50, 50, 60)
        # win.clear @clear_colour
        @starfield.draw(win)
        win.draw text "#{@score}", at: [5,5]
        object_types.each do |obj_class|
          obj_class.all.each do |obj_instance|
            obj_instance.render(win)
          end
        end
      end
    end
  end
end

