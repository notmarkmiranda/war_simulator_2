require './lib/card'

describe Card do
  let(:card_value) { 'ace' }
  let(:card_suit) { 'spades' }
  let(:card) { Card.new(card_value, card_suit) }

  context '#new' do
    it 'should be a kind of Card' do
      expect(card).to be_a_kind_of(Card)
    end

    it 'should have a value' do
      expect(card.value).to eq(card_value)
    end

    it 'should have a suit' do
      expect(card.suit).to eq(card_suit)
    end
  end

  context '#rank' do
    it 'should have ranks for all cards' do
      values = [*2..10].map(&:to_s).push('jack', 'queen', 'king', 'ace')
      values.each_with_index do |val, index|
        card = Card.new(val, card_suit)
        rank = index + 2
        expect(card.rank).to eq(rank)
      end
    end
  end
end