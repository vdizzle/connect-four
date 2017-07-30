require 'spec_helper'

describe ConnectFour::Piece do
  describe '#to_s' do
    context 'without formatting options' do
      it 'should return a space character for blank value' do
        expect(ConnectFour::Piece.new('').to_s).to eq(' ')
      end

      it 'should return uppercase value for non-blank value' do
        expect(ConnectFour::Piece.new('r').to_s).to eq('R')
      end
    end

    context 'with formatting options' do
      context 'without piece value matching a color provided' do
        it 'should return a space character for blank value' do
          expect(
             ConnectFour:: Piece.new('').to_s({ formatted: true, color_map: { b: :blue } })
          ).to eq(' ')
        end

        it 'should return uppercase value for non-blank value' do
          expect(
           ConnectFour:: Piece.new('r').to_s({ formatted: true, color_map: { b: :blue } })
          ).to eq('R')
        end
      end

      context 'with piece value matching a color provided' do
        it 'should return a formatted string' do
          expect(
            ConnectFour::Piece.new('r').to_s({ formatted: true, color_map: { r: :red } })
          ).to match /•/
        end
      end
    end
  end
end
