class Card
  attr_reader :value, :suit

  RANKS = {
    'jack' => 11,
    'queen' => 12,
    'king' => 13,
    'ace' => 14
  }

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def rank
    RANKS[value] || value.to_i
  end
end