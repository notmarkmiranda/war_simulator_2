require './lib/game'

describe Game do
  let(:game) { Game.new }
  context '#new' do
    it 'should be a kind of Game' do
      expect(game).to be_a_kind_of(Game)
    end

    it 'should have a deck that is a kind of a Deck' do
      expect(game.deck).to be_a_kind_of(Deck)
    end

    it 'should have a deck that has Card objects' do
      expect(game.deck.cards).to_not be_empty
      expect(game.deck.cards.first).to be_a_kind_of(Card)
      expect(game.deck.cards.last).to be_a_kind_of(Card)
    end

    it 'should have a player_one that is a kind of Player' do
      expect(game.player_one).to be_a_kind_of(Player)
    end

    it 'should have a player_two that is a kind of Player' do
      expect(game.player_two).to be_a_kind_of(Player)
    end

    it 'should have players that are not each other' do
      expect(game.player_one).to_not eq(game.player_two)
    end

    it 'should have a hand_count that starts at zero' do
      expect(game.hand_count).to eq(0)
    end
  end

  context '#deal' do
    before do 
      allow(game.deck).to receive(:shuffle!).and_call_original
      game.deal
    end

    it 'should shuffle the cards' do
      expect(game.deck).to have_received(:shuffle!).once
    end

    it 'should deal 26 cards to each player' do
      expect(game.player_one.hand_count).to eq(26)
      expect(game.player_two.hand_count).to eq(26)
      expect(game.deck.cards.count).to eq(0)
    end
  end

  context '#play' do
    let(:player_one) { game.player_one }
    let(:player_two) { game.player_two }
    let(:new_deck) { Deck.new }

    before { game.deal }

    context 'straight up' do
      it 'should give player_one the win' do
        expect(game).to receive(:is_there_a_tie?).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(27)
        expect(player_two.hand_count).to eq(25)
      end
      
      it 'should give player_two the win' do
        expect(game).to receive(:is_there_a_tie?).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p2).and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(25)
        expect(player_two.hand_count).to eq(27)
      end
    end

    context 'for full ties' do
      it 'should work out a tie and give 5 cards to player_one' do
        expect(game).to receive(:is_there_a_tie?).twice.and_return(true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(true)
        game.play
        
        
        expect(player_one.hand_count).to eq(31)
        expect(player_two.hand_count).to eq(21)
        expect(game.comparing[:p1]).to be_nil
        expect(game.comparing[:p2]).to be_nil
      end
      
      it 'should work out a tie and give 5 cards to player_two' do
        expect(game).to receive(:is_there_a_tie?).twice.and_return(true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p2).and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(21)
        expect(player_two.hand_count).to eq(31)
        expect(game.comparing[:p1]).to be_nil
        expect(game.comparing[:p2]).to be_nil
      end
      
      it 'should work out two ties with and give 9 cards to player_one' do
        expect(game).to receive(:is_there_a_tie?).exactly(3).times.and_return(true, true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return true
        game.play
        
        expect(player_one.hand_count).to eq(35)
        expect(player_two.hand_count).to eq(17)
        expect(game.comparing[:p1]).to be_nil
        expect(game.comparing[:p2]).to be_nil
      end
      
      it 'should work out two ties with and give 9 cards to player_two' do
        expect(game).to receive(:is_there_a_tie?).exactly(3).times.and_return(true, true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return false
        expect(game).to receive(:did_player_win?).with(:p2).and_return true
        game.play
        
        expect(player_one.hand_count).to eq(17)
        expect(player_two.hand_count).to eq(35)
        expect(game.comparing[:p1]).to be_nil
        expect(game.comparing[:p2]).to be_nil
      end
    end

    context 'for partial ties' do

      it 'should work out a single tie with less than 5 cards for one of the 2 players and give the win to player_one' do
        game.player_one.hand, game.player_two.hand = new_deck.cards.first(48), new_deck.cards.last(4)
        expect(game).to receive(:is_there_a_tie?).and_return(true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(true)
        game.play
  
        expect(player_one.hand_count).to eq(52)
        expect(player_two.hand_count).to eq(0)
      end
      
      it 'should work out a single tie with less than 5 cards for one of the 2 players and give the win to player_two' do
        game.player_two.hand, game.player_one.hand = new_deck.cards.first(48), new_deck.cards.last(4)
        expect(game).to receive(:is_there_a_tie?).and_return(true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p2).and_return(true)
        game.play
  
        expect(player_one.hand_count).to eq(0)
        expect(player_two.hand_count).to eq(52)
      end

      it 'should work out 2 ties with less than 5 cards on the second tie and give the win to player_one' do
        game.player_one.hand, game.player_two.hand = new_deck.cards.first(43), new_deck.cards.last(9)
        expect(game).to receive(:is_there_a_tie?).and_return(true, true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(true)
        game.play
  
        expect(player_one.hand_count).to eq(52)
        expect(player_two.hand_count).to eq(0)
      end
      
      it 'should work out 2 ties with less than 5 cards on the second tie and give the win to player_two' do
        game.player_two.hand, game.player_one.hand = new_deck.cards.first(43), new_deck.cards.last(9)
        expect(game).to receive(:is_there_a_tie?).and_return(true, true, false)
        expect(game).to receive(:did_player_win?).with(:p1).and_return(false)
        expect(game).to receive(:did_player_win?).with(:p2).and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(0)
        expect(player_two.hand_count).to eq(52)
      end
    end
    
    context 'for ties with no cards for war' do
      it 'ties on the last card and player_one gets the win' do
        game.player_one.hand, game.player_two.hand = new_deck.cards.first(51), new_deck.cards.last(1)
        expect(game).to receive(:is_there_a_tie?).once.and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(52)
        expect(player_two.hand_count).to eq(0)
      end

      it 'ties on the last card and player_two gets the win' do
        game.player_two.hand, game.player_one.hand = new_deck.cards.first(51), new_deck.cards.last(1)
        expect(game).to receive(:is_there_a_tie?).once.and_return(true)
        game.play
        
        expect(player_one.hand_count).to eq(0)
        expect(player_two.hand_count).to eq(52)
      end
    end

    context 'for second ties after one tie' do
      it 'ties twice and gives the win to player_one' do
        game.player_one.hand = new_deck.cards.first(47)
        game.player_two.hand = new_deck.cards.last(5) 
        expect(game).to receive(:is_there_a_tie?).twice.and_return(true, true)
        game.play

        expect(player_one.hand_count).to eq(52)
        expect(player_two.hand_count).to eq(0)
      end
      
      it 'ties twice and gives the win to player_two' do
        game.player_two.hand = new_deck.cards.first(47)
        game.player_one.hand = new_deck.cards.last(5) 
        expect(game).to receive(:is_there_a_tie?).twice.and_return(true, true)
        game.play
  
        expect(player_one.hand_count).to eq(0)
        expect(player_two.hand_count).to eq(52)
      end
    end
  end
end