require_relative "scraper.rb"

class Game
  attr_accessor :steam_id, :title, :price, :genres, :url, :description, :user_reviews, :release_date, :developer, :publisher
  @@all = []

  def initialize(game_hash)
    game_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this student object via the self.send method
    @@all << self #adds the instance to the class array to keep track of all the instances
  end
=begin
  def self.create_from_collection(game_array)
    game_array.each do |i| #iterates over the array of games and creates a new game for each hash in the array
      game = self.new(i)
    end
  end

  def add_game_attributes(attributes_hash)
    attributes_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this student object via the self.send method
    self #returns the self game object
  end
=end

  def self.create_from_steam_api
    #initially populates game objects from Steam Storefront API
    hash = Scraper.get_top_sellers
    hash.each do |item|
      game = self.new({
        steam_id: item["id"].to_i, #sometimes the ids come as strings, so forces into integer
        title: item["name"],
        price: item["final_price"] / 100.0 #forces conversion from 1099 into 10.99
        })
    end

    @@all.each do |game|
=begin
      hash = get_game_info(game[:steam_id])
      game[:genres] =
      game[:url] =
      game[:description] =
      game[:user_reviews] =
      game[:release_date] =
      game[:developer] =
      game[:publisher] =
=end
    end

    binding.pry
  end

  def self.all
    @@all
  end
end

Game.create_from_steam_api