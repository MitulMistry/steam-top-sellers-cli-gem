require_relative "game.rb"
require_relative "scraper.rb"

class CommandLineInteface

  def run
    Game.create_from_steam_api
    list_games
  end

  def list_games
    puts "--------- STEAM TOP SELLERS ---------"
    Game.all.each.with_index(1) do |game, index| #each.with_index(1) allows you to offset the index, unlike each_with_index
      puts "#{index}. #{game.title} - $#{game.price}"
    end

  end
=begin
  def print_game(game)

  end
=end
end

CommandLineInteface.new.run