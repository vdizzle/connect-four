module ConnectFour
  class Manager
    attr_reader :current_player

    def initialize(players, board)
      @players = players
      @board = board
      @current_player = players[rand(2)]
    end

    def process_play(input)
      board.play((input || '').strip.to_i, current_player.piece)
      switch_turns if game_state == :ongoing
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

    def board_string(options = { formatted: false, piece_color_map: {} })
      board.to_s(options)
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
