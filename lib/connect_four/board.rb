module ConnectFour
  class Board
    attr_reader :rows, :columns

    def initialize(rows, columns)
      raise ConnectFour::InvalidBoardSize if [columns, rows].min < 4
      @rows = rows
      @columns = columns
      @cells = rows.times.map { |i| Array.new(columns, 0) }
      @move_count = 0
      @gameplay_stack_pointer = columns.times.inject({}) do |result, current|
        result[current] = -1
        result
      end
      @last_played_cell = []
    end

    def play(column, player_symbol)
      target_column = column - 1
      raise ConnectFour::InvalidMove if gameplay_stack_pointer[target_column].nil?

      target_row = gameplay_stack_pointer[target_column] + 1
      mapped_indices = array_indices_to_board_map(target_row, target_column)
      mapped_row = mapped_indices.first
      mapped_column = mapped_indices.last

      raise ConnectFour::InvalidMove if mapped_row >= rows || mapped_row < 0

      cells[mapped_row][mapped_column] = player_symbol
      @last_played_cell = [target_row, target_column]
      gameplay_stack_pointer[mapped_column] += 1
      @move_count += 1
    end

    def show
      puts ''
      cells.each do |row|
        formatted_row = ''
        formatted_row << '|'
        row.each do |col|
          formatted_row << col.to_s
          formatted_row << '|'
        end
        puts formatted_row
      end
    end

    def has_winner?(player_symbol)
      return false if move_count < 7

      vertical_connected = vertical_four_connected(player_symbol, *last_played_cell)
      return true if vertical_connected

      horizontal_connected = horizontal_four_connected(player_symbol, *last_played_cell)
      return true if horizontal_connected

      left_to_right = diagonal_left_to_right_connected(player_symbol, *last_played_cell)
      return true if left_to_right

      diagonal_right_to_left_connected(player_symbol, *last_played_cell)
    end

    private

    def array_indices_to_board_map(row, column)
      [rows - row - 1, column]
    end

    def vertical_four_connected(player_symbol, row, column)
      return false if row < 0 || row >= rows
      return false if column < 0 || column >= columns

      connected_count = 0
      mapped_indices = array_indices_to_board_map(row, column)
      mapped_row = mapped_indices.first
      mapped_column = mapped_indices.last

      start_row = 0
      end_row = rows - 1

      (start_row..end_row).each do |current_row|
        cell_value = cells[current_row][mapped_column]
        if cell_value.to_s.downcase == player_symbol.to_s.downcase
          connected_count += 1
          return true if connected_count >= 4
        else
          connected_count = 0
        end

        false
      end

      false
    end

    def horizontal_four_connected(player_symbol, row, column)
      return false if row < 0 || row >= rows
      return false if column < 0 || column >= columns

      connected_count = 0
      mapped_indices = array_indices_to_board_map(row, column)
      mapped_row = mapped_indices.first
      mapped_column = mapped_indices.last
      player_series = []

      start_column = mapped_column - 3
      end_column = mapped_column + 3

      start_column = 0 if start_column < 0
      end_column = columns - 1 if end_column >= columns

      (start_column..end_column).each do |current_column|
        cell_value = cells[mapped_row][current_column]
        if cell_value.to_s.downcase == player_symbol.to_s.downcase
          connected_count += 1
          return true if connected_count >= 4
        else
          connected_count = 0
        end

        false
      end

      return true if player_series.count >= 4

      false
    end

    def diagonal_left_to_right_connected(player_symbol, row, column)
      return false if row < 0 || row >= rows
      return false if column < 0 || column >= columns

      mapped_indices = array_indices_to_board_map(row, column)
      puts mapped_indices.inspect
      puts "row, col - #{row}, #{column}"

	end

    def diagonal_right_to_left_connected(player_symbol, row, column)
	end

    attr_reader :cells, :move_count, :last_played_cell, :gameplay_stack_pointer
  end
end
