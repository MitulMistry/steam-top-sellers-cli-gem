class Game
  attr_accessor :title, :price, :genres, :url, :description, :user_reviews, :release_date, :developer, :publisher
  @@all = []

  def initialize(game_hash)
    game_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this student object via the self.send method
    @@all << self #adds the instance to the class array to keep track of all the instances
  end

  def self.create_from_collection(game_array)
    game_array.each do |i| #iterates over the array of games and creates a new game for each hash in the array
      game = self.new(i)
    end
  end

  def add_game_attributes(attributes_hash)
    attributes_hash.each { |key, value| self.send(("#{key}="), value) } #uses metaprogramming and mass assignment to assign all the values in the hash to this student object via the self.send method
    self #returns the self game object
  end

  def self.all
    @@all
  end
end