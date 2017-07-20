require './lib/connect_four/exceptions'

module ConnectFour
  autoload :Board, './lib/connect_four/board.rb'
  autoload :BotPlayer, './lib/connect_four/bot_player.rb'
  autoload :Player, './lib/connect_four/player.rb'
  autoload :Game, './lib/connect_four/game.rb'
  autoload :Manager, './lib/connect_four/manager.rb'
end
