require './lib/game'

class GameRunner
  def self.run_the_jewels(number=2)
    hand_count = []
    number.times do |n|
      g = Game.new
      g.deal
      count = g.play_entire_game
      hand_count << count
      puts "#{n + 1}: #{count}"
    end

    puts "#{hand_count.min}: #{hand_count.count { |hand| hand == hand_count.min }}"
    puts "MIN: #{hand_count.min}"
    puts ""
    puts "50K: #{hand_count.count { |hand| hand == 50_000.0 }}"
    puts "MAX: #{hand_count.max}"
    puts ""
    puts "AVG: #{hand_count.sum / hand_count.count.to_f}"
  end
end