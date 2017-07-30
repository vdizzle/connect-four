require 'spec_helper'

describe ConnectFour::Player do
  describe 'player creation' do
    context 'without initialization attributes' do
      it 'should raise MissingPlayerAttribute exception when name is missing' do
        expect {
          ConnectFour::Player.new(piece: 'X')
        }.to raise_error(ConnectFour::MissingPlayerAttribute)
      end

      it 'should raise MissingPlayerAttribute exception when piece is missing' do
        expect {
          ConnectFour::Player.new(name: 'Fearsome Four')
        }.to raise_error(ConnectFour::MissingPlayerAttribute)
      end
    end

    context 'with initialization attributes present' do
      let(:player) do
        ConnectFour::Player.new({ name: 'Fearsome Four', piece: 'r' })
      end

      it 'should convert piece to uppercase' do
        expect(player.piece).to eq(:r)
      end

      it 'should set player`s name' do
        expect(player.name).to eq('Fearsome Four')
      end
    end
  end

  describe '#to_s' do
    context 'without formatting options' do
      it 'should return  player name with piece info set at initialization' do
        player = ConnectFour::Player.new({ name: 'Fearsome Four', piece: 'r' })
        expect(player.to_s).to eq('Fearsome Four playing with piece R')
      end
    end

    context 'with formatting options' do
      it 'should return player name with piece info as •' do
        player = ConnectFour::Player.new({ name: 'Fearsome Four', piece: 'r' })
        player_string = player.to_s(formatted:true, color_map: { 'r': :red })
        expect(player_string).to match /Fearsome Four.* playing with piece.*•/
      end
    end
  end

  describe '#human?' do
    it 'should return true' do
      expect(
        ConnectFour::Player.new({ name: 'H', piece: 'r' }).human?
      ).to eq(true)
    end
  end
end
