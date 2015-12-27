require 'open-uri'
require 'nokogiri'
require 'json'
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
        url: item.css("a.tab_item_overlay").collect{ |link| link['href'] }.join,
        }
    end

    return_array.each do |i|
      x = i[:url].split("/") #splits the link into individual elements between the /s
      x.pop #gets rid of the ?info at the end of the link
      i[:steam_id] = x.last #sets the steam id to the end element of the link
      i[:url] = x.join("/") #joins the url and saves it without the ?info
    end

    binding.pry
    return_array
  end

  def self.scrape_game_page(game_url)
    #OPEN URL
    doc = Nokogiri::HTML(open(game_url)) #uses open-uri to open the url, then uses Nokogiri to parse in the html which we will then use to scrape data

    #PARSE PAGE FOR DATA
    return_hash = {
      description: doc.css("div.game_description_snippet").text,
      user_reviews: doc.css("div.glance_ctn div.glance_ctn_responsive_left").text,
      release_date: doc.css("div.release_date span.date").text
      }

    #NEED TO FIX THIS:
    return_hash[:user_reviews].gsub!("User reviews:", "").gsub!("Release Date:", "")#(/User reviews:|Release Date:|.{13}$/, "") #formats user review text - gets rid of "User reviews" string and dates (with last 13 characters)

    details_block = doc.css("div.game_details div.details_block")[0] #gets the first details_block on the page which contains the developer and publisher information
    detail_links = details_block.css("a").collect{ |link| link.text } #collects the text of the links in the block

    return_hash[:developer] = detail_links[detail_links.size - 1] #the developer is the second to last link in the links collected above
    return_hash[:publisher] = detail_links.last #the publisher is the last link in the links collected above

    #.gsub(/\\r|\\n|\\t/, '')
    return_hash.each { |key, value| value.gsub!( /\t|\n|\r/, "") } #normalizes text by getting rid of all the trailing and interstitial whitespace: \t, \n, \r with a regex

    return_hash
  end

end

#Scraper.scrape_top_sellers("http://store.steampowered.com/")
#Scraper.scrape_game_page("http://store.steampowered.com/app/220200/")