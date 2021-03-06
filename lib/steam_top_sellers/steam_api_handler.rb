class SteamAPIHandler
  #Steam Storefront API https://wiki.teamfortress.com/wiki/User:RJackson/StorefrontAPI
  def self.get_top_sellers
    doc = open("http://store.steampowered.com/api/featuredcategories/?cc=US") #uses Open-URI to get the JSON file, ?cc=US for US currency
    data_hash = JSON.load(doc) #loads the JSON data
    data_hash["top_sellers"]["items"] #selects desired part of hash
  end

  def self.get_game_info(steam_id)
    doc = open("http://store.steampowered.com/api/appdetails/?appids=#{steam_id}")#&filters=basic #uses Open-URI to get the JSON file based on steam ID
    data_hash = JSON.load(doc) #loads the JSON data
    data_hash[steam_id.to_s]["success"] == true ? data_hash[steam_id.to_s]["data"] : nil #selects desired part of hash, or returns nil if no data was acquired from API
  end
end
