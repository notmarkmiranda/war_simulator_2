require 'card'

class Deck
  attr_reader :cards
  
  def initialize
    @cards = create_all_the_cards
  end
  
  def card_count
    cards.count
  end
  
  private
  
  CARD_VALUES = [*2..10].map(&:to_s).push('jack', 'queen', 'king', 'ace')
  CARD_SUITS = ['spades', 'clubs', 'hearts', 'diamonds']

  def card_combinations
    CARD_SUITS.product(CARD_VALUES)
  end

  def create_all_the_cards
    card_combinations.map do |suit, value|
      Card.new(value, suit)
    end
  end
end