require './lib/connect_four'

game = ConnectFour::Game.new(
  ConnectFour::Player.new({ name: 'Hey', color: 'blue', value: 1 }),
  ConnectFour::Player.new({ name: 'Ho', color: 'yellow', value: -1 })
)
game.start
