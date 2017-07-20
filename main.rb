require './boot'

game = ConnectFour::Game.new(
  [
    ConnectFour::Player.new({ name: 'Hey', symbol: 'X' }),
    ConnectFour::Player.new({ name: 'Ho', symbol: 'Y' })
  ]
)
game.start
