require './lib/game_runner'

number_of_games = ARGV[0].to_i || 2

GameRunner.run_the_jewels(number_of_games)