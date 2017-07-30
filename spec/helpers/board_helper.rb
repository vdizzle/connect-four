module Helpers
  def preload_board_pieces(board, pieces, columns)
    columns.each_with_index do |column, index|
      board.play(column, pieces[index % 2])
    end
  end
end
