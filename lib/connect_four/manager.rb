module ConnectFour
  class Manager
    attr_reader :current_player

    def initialize(players, board)
      @players = players
      @board = board
      @current_player = players.first
    end

    def play_game
      puts 'Starting the ConnectFour game'
      puts "In turn, play by entering the column (1-#{board.columns}) value for the current player (e.g. 2):"
      puts 'Enter `exit` anytime to quit the game'
      puts "Enter move for player - #{current_player.name} with piece #{current_player.piece}"

      while (input = gets.chomp.upcase) != 'EXIT'
        begin
          board.play(input.strip.to_i, current_player.piece)
          Gem.win_platform? ? (system "cls") : (system "clear")
          board.show
        rescue ConnectFour::PositionNotOpen => e
          puts "No open position in column #{input}"
        rescue ConnectFour::InvalidMove => e
          puts "#{input} is not within the board"
        rescue StandardError => e
          puts e.inspect
          puts e.backtrace
        ensure
          if game_state == :ongoing
            switch_turns
            puts "Enter move for player - #{current_player.name} with piece #{current_player.piece}"
          else
            break
          end
        end
      end

      if game_state == :won
        puts "Player - #{current_player.name} playing with piece #{current_player.piece} has won"
      else
        puts "Game is tied"
      end
    end

    def game_state
      @game_state = if board.won?
                      :won
                    elsif board.tied?
                      :tied
                    else
                      :ongoing
                    end
    end

    def winner
      current_player if game_state == :won
    end

    private

    attr_reader :board, :players

    def switch_turns
      @current_player = current_player == players.first ? players.last : players.first
    end
  end
end
