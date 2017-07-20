module ConnectFour
  class Board
    attr_reader :rows, :columns

    def initialize(rows, columns)
      raise ConnectFour::InvalidBoardSize if [columns, rows].min < 4
      @rows = rows
      @columns = columns
      @cells = rows.times.map { |i| Array.new(columns, 0) }
      @stack_pointer = columns.times.inject({}) do |result, current|
        result[current] = -1
        result
      end
      @move_count = 0
    end

    def play(player, col)
      raise ConnectFour::InvalidMove if col >= columns
      raise ConnectFour::PositionNotOpen unless cells[row][col] == 0

      row = stack_pointer[col]
      cells[row][col] = player.symbol
      @move_count += 1
    end

    def has_winner?(player)
      return false if move_count < 7

      true
    end

    private

    attr_reader :cells, :move_count
  end
end
