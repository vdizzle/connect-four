module ConnectFour
  class Game
    def initialize(players, board_size = [6, 7])
      @board = ConnectFour::Board.new(*board_size)
      @player1 = player1
      @player2 = player2
      @state = ConnectFour::GameState.new(board, player1, player2)
    end

    def start
      puts 'Starting the ConnectFour game'
      puts "In turn, play by entering the row (1-#{board.row_size}), column (1-#{board.columns}) values  position for the current player (e.g. 2 3):"
      puts 'Enter `exit` anytime to quit the game'
      puts "Enter move for player - #{current_player.name}"

      while (input = gets.chomp.downcase) != 'exit'
        begin
          state.process(input)
          break if state.won?
        rescue ConnectFour::PositionNotOpen => e
          puts "A play has already been made at #{input}"
        rescue ConnectFour::InvalidMove => e
          puts "#{input} is not within the board"
        rescue StandardError => e
          puts e.inspect
        ensure
          unless state.completed?
            puts "Enter move for player - #{current_player.name}"
          end
        end
      end
    end

    private

    attr_reader :board, :players, :state

    def current_player
      state.current_player
    end
  end
end
