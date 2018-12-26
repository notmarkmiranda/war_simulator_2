require './lib/player'

describe Player do
  let(:player) { Player.new }

  context '#new' do
    it 'should be a kind of Player' do
      expect(player).to be_a_kind_of(Player)
    end

    it 'should have an empty hand to start' do
      expect(player.hand).to be_empty
    end
  end

  context '#hand' do
    let(:card_double) { instance_double('Card') }
    let(:hand) { Array.new(5, card_double) }

    before do
      expect(player.hand).to be_empty
      player.hand = hand
    end

    it 'should be able to receive cards' do
      expect(player.hand_count).to eq(5)
    end

    context '#add_to_bottom' do
      it 'can add a single card to the bottom' do
        player.add_to_bottom(card_double)
        
        expect(player.hand_count).to eq(6)
      end
      
      it 'can add multiple cards to the bottom' do
        card_array = Array.new(3, card_double)
        player.add_to_bottom(card_array)
        
        expect(player.hand_count).to eq(8)
      end
    end

    context '#hand_count' do
      it 'can count five cards' do
        expect(player.hand_count).to eq(5)
      end
    end

    context '#remove_from_top' do
      it 'should be able to remove one card from the top' do
        player.remove_from_top

        expect(player.hand_count).to eq(4)
      end
      
      it 'should be able to remove multiple cards from the top' do
        player.remove_from_top(2)

        expect(player.hand_count).to eq(3)
      end

      it 'raises an error if there are not enough cards in the hand' do
        expect{ player.remove_from_top(6) }.to raise_error(Player::NotEnoughCardsError)
      end
    end
  end
end