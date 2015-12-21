require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_top_sellers(store_url)
    return_array = [] #empty array that will contain the game hashes to return at the end of the method

    #OPEN URL
    doc = Nokogiri::HTML(open(store_url)) #uses open-uri to open the url, then uses Nokogiri to parse in the html which we will then use to scrape data

    #PARSE PAGE FOR DATA
    doc.css("div.tab_content#tab_topsellers_content div.tab_item").each do |item| #iterates over each game listing on the site, and gets name, location, and url
      return_array << { #pushes a hash of game data onto the array
        title: item.css("div.tab_item_name").text, #uses css to select the appropriate data
        price: item.css("div.discount_final_price").text,
        genres: item.css("div.tab_item_top_tags").text,
        #REFACTOR:
        url: item.css("a.tab_item_overlay").collect{ |link| link['href'] }.join
        #name: card.css(".student-name").text, #uses css to select the appropriate data
        #location: card.css(".student-location").text,
        #profile_url: "#{index_url}/#{card.css("a").collect{ |link| link['href'] }.join}" #ugly chained command to get the url
        }
    end

    #binding.pry

  end

  def self.scrape_game_page(game_url)
    #OPEN URL
    doc = Nokogiri::HTML(open(game_url)) #uses open-uri to open the url, then uses Nokogiri to parse in the html which we will then use to scrape data

    #PARSE PAGE FOR DATA
    
    binding.pry

  end

end

Scraper.scrape_top_sellers("http://store.steampowered.com/")