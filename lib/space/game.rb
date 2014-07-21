require_relative './game_object'
require_relative './ship'
require_relative './enemy'
require_relative './cooldown_timer'
require_relative './enemy'
require_relative './explosion'
require_relative './shot'
require_relative './bomb'


require_relative './scenes/invasion'

module Space
  class Game < Ray::Game
    def initialize
      super "Space"

      Scenes::Invasion.bind(self)

      scenes << :invasion
    end
  end
end

