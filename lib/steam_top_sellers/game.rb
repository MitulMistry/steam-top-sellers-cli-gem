#require_relative "steam_api_handler.rb"

class Game
  attr_accessor :steam_id, :title, :price, :genres, :website, :description, :user_reviews, :release_date, :developer, :publisher, :list_num, :api_success
  @@all = []

  def initialize(game_hash)
    game_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this game object via the self.send method
    @@all << self #adds the instance to the class array to keep track of all the instances
    self.list_num = @@all.size #sets its list number to its place in the array
    #self - don't need to return self, initialize is a special method that always returns self
  end

  def self.does_not_exist?(id)
    @@all.none?{ |i| id == i.steam_id } #checks to make sure an item with the same steam id doesn't already exist in the @@all class array
  end

  def self.create_from_steam_api #constructor
    #initially populates game objects from Steam Storefront API
    hash = SteamAPIHandler.get_top_sellers
    hash.each do |item|
      if Game.does_not_exist?(item["id"].to_i)
        game = self.new({
          steam_id: item["id"].to_i, #sometimes the ids come as strings, so forces into integer
          title: item["name"].gsub(/[™®]/, ''), #gets rid of ® ™ characters with a regex to make it easier to type in name from list
          price: item["final_price"] / 100.0 #forces conversion from 1099 into 10.99
          })
      end
    end

    #update_all_from_steam_api
  end

  def self.update_all_from_steam_api
    #updates list of games with more detailed info by getting Steam API data for each individual game
    @@all.each do |game|
      update_game_from_steam_api(game)
      #sleep(0.25) #sleep to slow down requests and try and avoid a timeout from server
    end
  end

  def self.update_game_from_steam_api(game)
    #updates list of games with more detailed info by getting Steam API data for each individual game
    if hash = SteamAPIHandler.get_game_info(game.steam_id) #assigns hash and checks if it has a value or is nil
      game.genres = hash["genres"] #array of hashes: [{"id"=>"1", "description"=>"Action"}, {"id"=>"23", "description"=>"Indie"}, {"id"=>"2", "description"=>"Strategy"}, {"id"=>"70", "description"=>"Early Access"}]
      game.website = hash["website"]
      game.description = Nokogiri::HTML(hash["about_the_game"]).text #Gets rid of html tags like <h2> and \r
      hash.has_key?("recommendations") ? game.user_reviews = "#{hash['recommendations']['total']} user reviews" : game.user_reviews = "No reviews yet" # checks to see if there are any reviews yet
      game.release_date = hash["release_date"] #hash: {"coming_soon"=>false, "date"=>"Dec 14, 2015"}
      game.developer = hash["developers"] #array: ["Offworld Industries"]
      game.publisher = hash["publishers"] #array: ["Offworld Industries"]
      game.api_success = true
    else
      game.api_success = false
    end
  end

  #accessor method for the @@all class array
  def self.all
    @@all
  end
end