class Player
  attr_accessor :hand
  
  def initialize
    @hand = []
  end

  def add_to_bottom(cards)
    hand.push(cards).flatten!
  end

  def hand_count
    hand.count
  end

  def remove_from_top(cards=1)
    raise NotEnoughCardsError if cards > hand_count
    hand.shift(cards)
  end

  class NotEnoughCardsError < StandardError; end
end