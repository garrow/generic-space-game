module Space
  module Scenes
    class Invasion < Ray::Scene

      scene_name :invasion

      attr_reader :object_types

      def setup
        @object_types = [Shot, Ship, Enemy, Explosion, Bomb]
        Ship.create(window.size)
        10.times do
          Enemy.create(rand(window.size.x), rand(window.size.y / 2))
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
              Explosion.create(shot.x, shot.y)
            end
          end
        end

        ship = Ship.get
        Bomb.all.each do |bomb|
          x = bomb.x - ship.x
          y = bomb.y - ship.y
          if x.abs < 15 && y.abs < 15
            puts "game over"

            Explosion.create(bomb.x, bomb.y)
            #   bomb.destroy
            #   ship.destroy

          end
        end
      end

      def render(window)
        @clear_colour ||= Ray::Color.new(50, 50, 60)
        window.clear @clear_colour
        object_types.each do |obj_class|
          obj_class.all.each do |obj_instance|
            puts "#{obj_class} #{obj_instance.x}:#{obj_instance.y} "
            obj_instance.render(window)
          end
        end
      end
    end
  end
end

