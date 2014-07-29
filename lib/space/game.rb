require_relative './game_object'
require_relative './ship'
require_relative './enemy'
require_relative './cooldown_timer'
require_relative './enemy'
require_relative './explosion'
require_relative './shot'
require_relative './bomb'
require_relative './starfield'

require_relative './sprite_loader'


require_relative './scenes/invasion'
require_relative './scenes/title'

module Space
  class Game < Ray::Game
    def initialize
      super "Space"

      Scenes::Invasion.bind(self)
      Scenes::Title.bind(self)

      scenes << :title
    end
  end
end

