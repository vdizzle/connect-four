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
      @last_played_position = {}
    end

    def play(column, piece)
      target_column = column - 1
      raise ConnectFour::InvalidMove if column_tracker[target_column].nil?

      target_row = column_tracker[target_column] - 1

      raise ConnectFour::PositionNotOpen if target_row < 0 || target_row >= rows

      @last_played_position = { row: target_row, column: target_column }
      set_board_piece_at(last_played_position, piece)
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

    def won?
      return false if move_count < 7

      piece = get_board_piece_at(last_played_position)

      four_connected?(piece, last_played_position, nil) ||
      four_connected?(piece, last_played_position, 0) ||
      four_connected?(piece, last_played_position, 1) ||
      four_connected?(piece, last_played_position, -1)
    end

    def tied?
      board_full? && !won?
    end

    def winning_piece
      get_board_piece_at(last_played_position) if won?
    end

    private

    def status
      [:ongoing, :won, :tied]
    end

    def board_full?
      column_tracker.values.uniq == [0]
    end

    def set_board_piece_at(position, piece)
      cells[position[:row]][position[:column]] = piece
    end

    def get_board_piece_at(position)
      cells[position[:row]][position[:column]]
    end

    def matching_piece?(piece, position)
      piece == get_board_piece_at(position)
    end

    def position_within_board?(position)
      position[:row] >= 0 && position[:row] < rows && position[:column] >= 0 && position[:column] < columns
    end

    def four_connected?(piece, ref_position, slope)
      step = slope_to_step(slope)
      inspect_positions = [ref_position]

      (1..3).each do |i|
        right_of_ref_position = {
          row: ref_position[:row] + (i * step[:row]),
          column: ref_position[:column] + (i * step[:column])
        }
        left_of_ref_position = {
          row: ref_position[:row] - (i * step[:row]),
          column: ref_position[:column] - (i * step[:column])
        }
        inspect_positions << right_of_ref_position if position_within_board?(right_of_ref_position)
        inspect_positions.unshift(left_of_ref_position) if position_within_board?(left_of_ref_position)
      end

      connected_count = 0
      inspect_positions.each do |position|
        if matching_piece?(piece, position)
          connected_count += 1
          return true if connected_count >= 4
        else
          connected_count = 0
        end
      end

      connected_count >= 4
    end

    def slope_to_step(slope)
      case slope
      when 0
        { row: 0, column: 1 }
      when 1
        { row: -1, column: 1 }
      when -1
        { row: 1, column: 1 }
      else
        { row: 1, column: 0 }
      end
    end

    attr_reader :cells, :move_count, :last_played_position, :column_tracker
  end
end
