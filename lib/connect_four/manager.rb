module ConnectFour
  class Manager
    attr_reader :current_player

    def initialize(players, board)
      assert_valid_players!(players)

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

    def assert_valid_players!(players)
      raise ConnectFour::InvalidPlayerCount if players.size != 2

      player_types = []
      player_pieces = []

      unless players.map { |p| p.class }.uniq == [ConnectFour::Player]
        raise ConnectFour::InvalidPlayerType
      end

      unless players.map { |p| p.piece }.uniq.size == 2
        raise ConnectFour::DuplicatePlayer
      end
    end

    def switch_turns
      @current_player = current_player == players.first ? players.last : players.first
    end
  end
end
