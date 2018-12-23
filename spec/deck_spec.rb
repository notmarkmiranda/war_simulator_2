require './lib/deck'

describe Deck do
  let(:deck) { Deck.new }

  context '#new' do
    it 'should be a kind of Deck' do
      expect(deck).to be_a_kind_of(Deck)
    end

    it 'should instantiate with 52 cards' do
      expect(deck.cards).to_not be_empty
    end
  end

  context '#card_count' do
    it 'should have 52 cards after initialization' do
      expect(deck.card_count).to eq(52)
    end
  end
end