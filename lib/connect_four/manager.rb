module ConnectFour
  class Manager
    attr_reader :current_player

    def initialize(board, players)
      @board = board
      @players = players
      @current_player = players.first
      @winner = nil
    end

    def process(input)
      column = input.strip.to_i
      raise ConnectFour::InvalidMove if column == 0

      board.play(current_player, column - 1)

      if board.has_winner?(current_player)
        @winner = current_player
        return
      end

      @current_player = switch_turns
    end

    def game_completed?
      !winner.nil?
    end

    private

    attr_reader :board, :players, :winner

    def switch_turns
      current_player == players.first ? players.last : players.first
    end
  end
end
