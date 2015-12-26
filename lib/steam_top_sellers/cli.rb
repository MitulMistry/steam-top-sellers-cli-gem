require_relative "game.rb"
require_relative "scraper.rb"

class CommandLineInteface

  def run
    Game.create_from_steam_api
    list_games

    input = nil
    while input != "exit"
      puts ""
      puts "What movie would you more information on, by name or number?"
      puts "Enter list to see the games again. Enter exit to end."
      puts ""
      input = gets.chomp
      if input == "list"
        list_games
      elsif input.to_i.between?(1, Game.all.size) #checks the size of how many games have been loaded
        print_game_by_list_number(input.to_i)
      else
        puts "Invalid. Try again."
      end
    end
    puts "Goodbye."
  end

  def list_games
    puts "--------- STEAM TOP SELLERS ---------"
    Game.all.each.with_index(1) do |game, index| #each.with_index(1) allows you to offset the index, unlike each_with_index
      puts "#{index}. #{game.title} - $#{game.price}"
      game.list_num = index
    end

  end

  def print_game_by_list_number(number)
    print_game(Game.all.detect {|i| i.list_num == number})
  end

  def print_game(game)
    puts "--------- #{game.title} ---------"
    #game.release_date["coming_soon"] ? puts "Coming soon" : puts "Released: #{game.release_date}" #hash: {"coming_soon"=>false, "date"=>"Dec 14, 2015"}
    if game.release_date["coming_soon"]
      puts "Coming soon"
    else
      puts "Released: #{game.release_date}"
    end
    #puts "Released: #{game.release_date}" #hash: {"coming_soon"=>false, "date"=>"Dec 14, 2015"}
    puts "Genres: #{game.genres.collect {|i| i["description"]} }" #array of hashes: [{"id"=>"1", "description"=>"Action"}, {"id"=>"23", "description"=>"Indie"}
    puts "#{game.user_reviews}"
    puts "Website: #{game.website}"
    puts "Developer: #{game.developer}"
    puts "Publisher: #{game.publisher}"
    puts "Description: #{game.description}"
  end

end

CommandLineInteface.new.run