require_relative "steam_api_handler.rb"

class Game
  attr_accessor :steam_id, :title, :price, :genres, :website, :description, :user_reviews, :release_date, :developer, :publisher, :list_num
  @@all = []

  def initialize(game_hash)
    game_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this student object via the self.send method
    @@all << self #adds the instance to the class array to keep track of all the instances
    self
  end

  def self.create_from_steam_api #constructor
    #initially populates game objects from Steam Storefront API
    hash = SteamAPIHandler.get_top_sellers
    hash.each do |item|
      if @@all.none?{ |i| item["id"].to_i == i.steam_id } #checks to make sure an item with the same steam id doesn't already exist in the @@all class array
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
    hash = SteamAPIHandler.get_game_info(game.steam_id)
    game.genres = hash["genres"] #array of hashes: [{"id"=>"1", "description"=>"Action"}, {"id"=>"23", "description"=>"Indie"}, {"id"=>"2", "description"=>"Strategy"}, {"id"=>"70", "description"=>"Early Access"}]
    game.website = hash["website"]
    game.description = Nokogiri::HTML(hash["about_the_game"]).text #Gets rid of html tags like <h2> and \r
    game.user_reviews = "#{hash['recommendations']['total']} user reviews"
    game.release_date = hash["release_date"] #hash: {"coming_soon"=>false, "date"=>"Dec 14, 2015"}
    game.developer = hash["developers"] #array: ["Offworld Industries"]
    game.publisher = hash["publishers"] #array: ["Offworld Industries"]
  end

  #accessor method for the @@all class array
  def self.all
    @@all
  end
end