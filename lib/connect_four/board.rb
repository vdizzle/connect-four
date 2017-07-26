module ConnectFour
  class Board
    attr_reader :rows, :columns

    def initialize(rows, columns)
      raise ConnectFour::InvalidBoardSize if [columns, rows].min < 4
      @rows = rows
      @columns = columns
      @cells = rows.times.map { |i| Array.new(columns, 0) }
      @column_tracker = columns.times.inject({}) do |result, current|
        result[current] = rows
        result
      end
      @move_count = 0
      @active_cell = {}
    end

    def play(column, piece)
      target_column = column - 1
      raise ConnectFour::InvalidMove if column_tracker[target_column].nil?

      target_row = column_tracker[target_column] - 1

      raise ConnectFour::InvalidMove if target_row < 0 || target_row >= rows

      @active_cell = { row: target_row, column: target_column }
      set_board_piece_at(active_cell, piece)
      column_tracker[target_column] -= 1
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

    def has_winner?(piece)
      return false if move_count < 7

      vertical_connected = vertical_four_connected?(piece, active_cell)
      return true if vertical_connected

      horizontal_connected = horizontal_four_connected?(piece, active_cell)
      return true if horizontal_connected

      diagonal_connected = diagonal_positive_slope_four_connected?(piece, active_cell)
      return true if diagonal_connected

      diagonal_negative_slope_four_connected?(piece, active_cell)
    end

    private

    def set_board_piece_at(cell_position, piece)
      cells[cell_position[:row]][cell_position[:column]] = piece
    end

    def get_board_piece_at(cell_position)
      cells[cell_position[:row]][cell_position[:column]]
    end

    def matching_piece?(piece, cell)
      piece = get_board_piece_at(cell)
    end

    def vertical_four_connected?(piece, cell)
      start_row = cell[:row] - 3
      end_row = cell[:row] + 3

      start_row = 0 if start_row < 0
      end_row = rows - 1 if end_row >= rows

      four_connected?(
        piece,
        { row: start_row, column: cell[:column] },
        { row: end_row, column: cell[:column] },
        { row: 1, column: 0 }
      )
    end

    def horizontal_four_connected?(piece, cell)
      start_column = cell[:column] - 3
      end_column = cell[:column] + 3

      start_column = 0 if start_column < 0
      end_column = columns - 1 if end_column >= columns

      four_connected?(
        piece,
        { row: cell[:row], column: start_column },
        { row: cell[:row], column: end_column },
        { row: 0, column: 1 }
      )
    end

    def diagonal_positive_slope_four_connected?(piece, cell)
      start_row = cell[:row] + 3
      start_column = cell[:column] - 3

      end_row = cell[:row] - 3
      end_column = cell[:column] + 3

      start_row = rows - 1 if start_row >= rows
      end_row = 0 if end_row < 0
      start_column = 0 if start_column < 0
      end_column = columns - 1 if end_column >= columns

      four_connected?(
        piece,
        { row: start_row, column: start_column },
        { row: end_row, column: end_column },
        { row: -1, column: 1 }
      )
    end

  def diagonal_negative_slope_four_connected?(piece, cell)
      start_row = cell[:row] + 3
      start_column = cell[:column] - 3

      end_row = cell[:row] + 3
      end_column = cell[:column] + 3

      start_row = 0 if start_row < 0
      end_row = rows - 1 if end_row >= rows
      start_column = 0 if start_column < 0
      end_column = columns - 1 if end_column >= columns

      four_connected?(
        piece,
        { row: start_row, column: start_column },
        { row: end_row, column: end_column },
        { row: 1, column: 1 }
      )
    end


    def four_connected?(piece, start_cell, end_cell, step)
      target_cell = start_cell
      connected_count = 0

      loop do
        if matching_piece?(piece, target_cell)
          connected_count += 1
          return true if connected_count >= 4
        else
          connected_count = 0
        end

        target_cell[:row] += step[:row]
        target_cell[:column] += step[:column]

        if target_cell == end_cell
          connected_count += 1 if matching_piece?(piece, target_cell)
          break
        end
      end

      connected_count >= 4
    end

    attr_reader :cells, :move_count, :active_cell, :column_tracker
  end
end
