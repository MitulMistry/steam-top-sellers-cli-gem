require_relative "game.rb"

class CommandLineInterface
  def run
    Game.create_from_steam_api
    list_games

    input = nil
    while input != "exit"
      puts ""
      puts "What game would you like more information on, by name or number?"
      puts "Enter list to see the games again. Enter exit to end."
      puts ""
      input = gets.chomp.downcase
      if input == "list"
        list_games
      elsif input.to_i.between?(1, Game.all.size) #checks the size of how many games have been loaded
        print_game_by_list_number(input.to_i)
      elsif Game.all.any?{|i| input == i.title.downcase } #checks to see if there's any game title matching input
        print_game_by_title(input)
      elsif input != "exit"
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
    game = Game.all.detect {|i| i.list_num == number} #retrieves the game from the Game class's @@all array based on list number
    Game.update_game_from_steam_api(game)
    print_game(game)
  end

  def print_game_by_title(input)
    game = Game.all.detect {|i| i.title.downcase == input} #retrieves the game from the Game class's @@all array based on title
    Game.update_game_from_steam_api(game)
    print_game(game)
  end

  def print_game(game)
    puts "--------- #{game.title} ---------"
    if game.release_date["coming_soon"] #hash: {"coming_soon"=>false, "date"=>"Dec 14, 2015"}
      puts "Released: Coming soon"
    else
      puts "Released: #{game.release_date["date"]}"
    end
    puts "Genres: #{game.genres.collect {|i| i["description"]}.join(", ") }" #array of hashes: [{"id"=>"1", "description"=>"Action"}, {"id"=>"23", "description"=>"Indie"}]
    puts "Recommendations: #{game.user_reviews}"
    puts "Website: #{game.website}"
    puts "Developer: #{game.developer.join(", ")}"
    puts "Publisher: #{game.publisher.join(", ")}"
    puts "Description: #{game.description}"
    puts "----------------------------------"
  end
end

CommandLineInterface.new.run