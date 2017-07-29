require 'spec_helper'

describe 'ConnectFour::Board' do
  describe 'board creation' do
    context 'with a board smaller than 4 row/colum' do
      it 'should raise InvalidBoardSize exception if invalid row size' do
        expect {
          ConnectFour::Board.new(1, 7)
        }.to raise_error(ConnectFour::InvalidBoardSize)
      end

      it 'should raise InvalidBoardSize exception if invalid column size' do
        expect {
          ConnectFour::Board.new(6, 3)
        }.to raise_error(ConnectFour::InvalidBoardSize)
      end
    end

    context 'with a valid board size' do
      it 'should create a board' do
        board = ConnectFour::Board.new(6, 7)
        expect(board.rows).to eq(6)
        expect(board.columns).to eq(7)
      end
    end
  end

  describe '#play' do
    let(:board) { ConnectFour::Board.new(6, 7) }

    context 'with a play to a cell outside range' do
      it 'should raise InvalidMove exception if invalid column' do
        expect {
          board.play(8, 'Y')
        }.to raise_error(ConnectFour::InvalidMove)
      end

      it 'should raise InvalidMove exception if column has no open position' do
        6.times { board.play(2, 'Y') }

        expect {
          board.play(2, 'Y')
        }.to raise_error(ConnectFour::PositionNotOpen)
      end
    end
  end

  describe '#won?' do
    let(:board) { ConnectFour::Board.new(6, 7) }

    context 'with less than four connected symbols' do
      it 'should return false' do
        3.times { board.play(1, 'R') }

        expect(board.won?).to eq(false)
      end
    end

    context 'with four vertical connected symbols' do
      it 'should find vertically connected symbols' do
        3.times { board.play(1, 'R') }
        4.times { board.play(2, 'Y') }

        expect(board.won?).to eq(true)
      end
    end

    context 'with four horizontal connected symbols' do
      it 'should find horizontally connected symbols' do
        (5..7).each { |i| board.play(i, 'Y') }
        (1..4).each { |i| board.play(i, 'R') }

        expect(board.won?).to eq(true)
      end
    end

    context 'with four diagonally connected symbols with positive slope' do
      it 'should find the connected symbols' do
        board.play(3, 'Y')
        board.play(3, 'R')
        board.play(3, 'Y')
        board.play(2, 'R')
        board.play(2, 'Y')
        board.play(4, 'R')
        board.play(4, 'Y')
        board.play(4, 'R')
        board.play(5, 'Y')
        board.play(5, 'R')
        board.play(5, 'Y')
        board.play(5, 'R')

        expect(board.won?).to eq(true)
      end
    end

    context 'with four diagonally connected symbols with negative slope' do
      it 'should find the connected symbols' do
        board.play(2, 'Y')
        board.play(3, 'R')
        board.play(4, 'Y')
        board.play(5, 'R')
        board.play(5, 'Y')
        board.play(4, 'R')
        board.play(3, 'Y')
        board.play(3, 'R')
        board.play(2, 'Y')
        board.play(1, 'R')
        board.play(2, 'Y')
        board.play(2, 'R')

        expect(board.won?).to eq(true)
      end
    end

  end
end
