require './lib/deck'
require './lib/player'

class Game
  attr_reader :deck, :player_one, :player_two, :hand_count
  attr_accessor :comparing, :escrow

  def initialize
    @deck = Deck.new
    @player_one = Player.new
    @player_two = Player.new
    @hand_count = 0
    @comparing = { p1: nil, p2: nil }
    @escrow = []
  end

  def deal
    deck.shuffle!
    index = 0
    until deck.cards.empty?
      players[index % 2].add_to_bottom(deck.cards.pop)
      index += 1
    end
  end

  def play
    p1, p2 = player_one.remove_from_top, player_two.remove_from_top
    winner = compare_cards(p1: p1, p2: p2)
    winner.add_to_bottom([comparing[:p1], comparing[:p2], escrow].flatten)
    clear_comparing
    clear_escrow
  end

  def play_entire_game
    hand_count = 0
    until smallest_hand_size.zero?
      play
      hand_count += 1
    end
    hand_count
  end

  private 

  def add_cards_to_escrow
    players.each do |player|
      escrow.push(player.remove_from_top(cards_to_pull))
    end
    escrow.flatten!
  end

  def cards_to_pull
    smallest_hand_size < 4 ? smallest_hand_size - 1 : 3
  end

  def clear_comparing
    comparing[:p1], comparing[:p2] = nil
  end

  def clear_escrow
    @escrow = []
  end

  def compare_cards(p1: nil, p2: nil, automatic_winner: nil)
    return automatic_winner if automatic_winner
    comparing[:p1], comparing[:p2] = p1, p2 
    return tie_mechanics if is_there_a_tie?
    return player_one if did_player_win?(:p1)
    player_two if did_player_win?(:p2)
  end

  def did_player_win?(player)
    return comparing[:p1].rank > comparing[:p2].rank if player == :p1
    comparing[:p1].rank < comparing[:p2].rank
  end

  def do_both_players_have_cards_left?
    players.find { |player| player.hand_count.zero? }.nil?
  end

  def is_there_a_tie?
    comparing[:p1].rank == comparing[:p2].rank
  end

  def players
    [player_one, player_two]
  end

  def smallest_hand_size
    players.map(&:hand_count).min
  end

  def the_non_zero_player
    players.reject { |player| player.hand_count.zero? }.first
  end
  
  def tie_mechanics
    return compare_cards(automatic_winner: the_non_zero_player) unless do_both_players_have_cards_left?
    move_comparing_to_escrow
    p1, p2 = player_one.remove_from_top, player_two.remove_from_top
    compare_cards(p1: p1, p2: p2)
  end

  def move_comparing_to_escrow
    escrow.push(comparing[:p1], comparing[:p2])
    clear_comparing
    add_cards_to_escrow
  end
end