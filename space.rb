require 'ray'
require 'pry'

require_relative './lib/ray/drawable'

require_relative './lib/space/game'

game = Space::Game.new

game.run
