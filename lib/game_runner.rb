require './lib/game'

class GameRunner
  def self.run_the_jewels(number=2)
    starting = Time.now
    hand_count = []
    mode_hash = Hash.new(0)

    number.times do |n|
      g = Game.new
      g.deal
      count = g.play_entire_game
      hand_count << count
      mode_hash[count] += 1
      puts "still running, game ##{n + 1}" if (n + 1) % 512 == 0
    end

    ending = Time.now
    mode_array = mode_hash.sort_by { |k,v| v }[-1]
    mode_hand_count = mode_array[0]
    mode_game_count = mode_array[1]
    

    puts ""
    puts "Ran #{number} games in #{ending - starting} seconds!"
    puts "Minimum Hands: #{hand_count.min}"
    puts "#{hand_count.min} games: #{mode_hash[hand_count.min]}"
    puts ""
    puts "Max Hands: #{hand_count.max}"
    puts "#{hand_count.max} games: #{mode_hash[hand_count.max]}"
    puts ""
    puts "Average: #{hand_count.sum / hand_count.count.to_f} hands"
    puts "Mode: #{mode_hand_count} hands, #{mode_game_count} times"
  end
end