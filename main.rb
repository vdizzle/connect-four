require './boot'

BOARD_ROW_SIZE = 6
BOARD_COLUMN_SIZE = 7
PIECES = [:b, :r]
PIECE_COLOR_MAP = { :b => :blue, :r => :red }
format_options = { formatted: true, color_map: PIECE_COLOR_MAP }

puts '*'*60
puts "Welcome to the Connect4 game"
puts '*'*60

players = []
PIECES.each_with_index do |piece, index|
  puts "Enter name for Player #{index + 1} (A random name used is not entered):"
  name = gets.chomp
  if name.blank?
    name = Faker::Name.name
    puts "Creating player with a random name: #{name}"
  end
  players << ConnectFour::Player.new({ name: (name.titleize), piece: piece })
end
puts '*'*60

game_manager = ConnectFour::Manager.new(
  players,
  ConnectFour::Board.new(*[BOARD_ROW_SIZE, BOARD_COLUMN_SIZE])
)

puts 'Starting the ConnectFour game'
puts "In turn, play by entering the column (1-#{BOARD_COLUMN_SIZE}) for the current player:"
puts 'Enter `exit` anytime to quit the game'
puts '*'*60
puts "#{game_manager.current_player.to_s(format_options)} has been randomly chosen to start first"
puts "Enter any key to start playing"
gets

error = ""
display = ""

loop do
  Gem.win_platform? ? (system 'cls') : (system 'clear')
  display = game_manager.board_string(formatted: true, color_map: PIECE_COLOR_MAP)
  unless error.blank?
    display << error
  end
  puts display

  break unless game_manager.game_state == :ongoing
  puts "Enter move (1-#{BOARD_COLUMN_SIZE}) for player - #{game_manager.current_player.to_s(format_options)}"
  input = gets.chomp.upcase
  break if input == 'EXIT'

  begin
    game_manager.process_play(input)
    error = ""
  rescue ConnectFour::PositionNotOpen => e
    error = "No open position in column #{input}"
  rescue ConnectFour::InvalidMove => e
    error = "Please enter a value in the range (1-#{BOARD_COLUMN_SIZE})"
  rescue StandardError => e
    puts e.inspect
    puts e.backtrace
    error = e.message
  end
end

case game_manager.game_state
when :won
  puts "Player #{game_manager.winner.to_s(format_options)} has won."
when :tied
  puts "Game Tied."
else
  puts "Game abandoned."
end
