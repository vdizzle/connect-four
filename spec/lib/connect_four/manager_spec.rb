require 'spec_helper'

describe ConnectFour::Manager do
  let(:player1) do
    ConnectFour::Player.new({ name: 'Fearsome Four', piece: :b })
  end

  let(:player2) do
    ConnectFour::Player.new({ name: 'Red Rugger', piece: :r })
  end

  let(:board) { ConnectFour::Board.new(6, 7) }

  describe 'initialization' do
    context 'with one player' do
      it 'should raise InvalidPlayerCount exception' do
        expect {
          ConnectFour::Manager.new([player1], board)
        }.to raise_error(ConnectFour::InvalidPlayerCount)
      end
    end

    context 'with more than two players' do
      it 'should raise InvalidPlayerCount exception' do
        expect {
          ConnectFour::Manager.new(
            [player1, player2, ConnectFour::Player.new({ name: 'W', piece: :w  })],
            board
          )
        }.to raise_error(ConnectFour::InvalidPlayerCount)
      end
    end

    context 'with exactly two players' do
      context 'with at least one player not of type ConnectFour::Player' do
        it 'should raise InvalidPlayerType exception' do
          expect {
            ConnectFour::Manager.new(
              [player1, Object.new],
              board
            )
          }.to raise_error(ConnectFour::InvalidPlayerType)
        end
      end

      context 'with both players with the same piece' do
        it 'should raise DuplicatePlayer exception' do
          expect {
            ConnectFour::Manager.new(
              [player1, player1],
              board
            )
          }.to raise_error(ConnectFour::DuplicatePlayer)
        end
      end

      context 'with both players of valid type with unique piece' do
        it 'should create a Manager object' do
          expect {
            ConnectFour::Manager.new([player1, player2], board)
          }.not_to raise_error
        end

        it 'should randomly set one of the players as current player' do
          manager = ConnectFour::Manager.new([player1, player2], board)
          expect([player1, player2]).to include(manager.current_player)
        end
      end
    end
  end

  describe 'process_play' do
    let(:manager) do
      ConnectFour::Manager.new([player1, player2], board)
    end

    it 'should invoke board `play` method with current player`s piece' do
      expect(board).to receive(:play).with(1, manager.current_player.piece)
      manager.process_play('1')
    end

    context 'with game in ongoing status' do
      before do
        expect(manager).to receive(:game_state).and_return(:ongoing)
      end

      it 'should switch to the next player as current player' do
        previous_player = manager.current_player
        manager.process_play('1')
        expect(manager.current_player).not_to eq(previous_player)
      end
    end

    context 'with game not in ongoing status' do
      it 'should not switch current player when game is won' do
        expect(manager).to receive(:game_state).and_return(:won)
        previous_player = manager.current_player
        manager.process_play('1')
        expect(manager.current_player).to eq(previous_player)
      end

      it 'should not switch current player when game is tied' do
        expect(manager).to receive(:game_state).and_return(:tied)
        previous_player = manager.current_player
        manager.process_play('1')
        expect(manager.current_player).to eq(previous_player)
      end
    end
  end

  describe '#winner' do
    let(:manager) do
      ConnectFour::Manager.new([player1, player2], board)
    end

    context 'when the game is not won' do
      it 'should return nil' do
        expect(manager).to receive(:game_state).and_return(:tied)
        expect(manager.winner).to be_nil
      end
    end

    context 'when the game is won' do
      it 'should return current player' do
        expect(manager).to receive(:game_state).and_return(:won)
        expect(manager.winner).to eq(manager.current_player)
      end
    end
  end
end
