require './boot'

manager = ConnectFour::Manager.new(
  [
    ConnectFour::Player.new({ name: 'Hey', piece: 'Y' }),
    ConnectFour::Player.new({ name: 'Ho', piece: 'R' })
  ],
  ConnectFour::Board.new(*[6, 7])
)
manager.play_game
