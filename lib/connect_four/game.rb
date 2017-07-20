module ConnectFour
  class Game
    def initialize(players, board_size = [6, 7])
      @board = ConnectFour::Board.new(*board_size)
      @players = players
      @manager = ConnectFour::Manager.new(board, players)
    end

    def start
      puts 'Starting the ConnectFour game'
      puts "In turn, play by entering the row (1-#{board.rows}), column (1-#{board.columns}) values  position for the current player (e.g. 2 3):"
      puts 'Enter `exit` anytime to quit the game'
      puts "Enter move for player - #{current_player.name}"

      while (input = gets.chomp.downcase) != 'exit'
        begin
          manager.process(input)
          break if manager.game_completed?
        rescue ConnectFour::PositionNotOpen => e
          puts "A play has already been made at #{input}"
        rescue ConnectFour::InvalidMove => e
          puts "#{input} is not within the board"
        rescue StandardError => e
          puts e.inspect
        ensure
          unless manager.game_completed?
            puts "Enter move for player - #{current_player.name}"
          end
        end
      end
    end

    private

    attr_reader :board, :players, :manager

    def current_player
      manager.current_player
    end
  end
end
