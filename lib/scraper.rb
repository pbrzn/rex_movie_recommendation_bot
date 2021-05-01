require 'nokogiri'
require 'open-uri'
# require 'pry'

class Scraper

  def self.streamer_scraper(streaming_service)
    streamer = Nokogiri::HTML(open("http://www.justwatch.com/us/provider/#{streaming_service.downcase.gsub(" ", "-")}/movies"))
    movies = streamer.css("div.title-list-grid__item")

    movies.map do |movie|
      film = {}
      film[:name] = movie.css("img.picture-comp__img").attribute("alt").text
      film[:url] = movie.css("a").attribute("href").value
      film[:streamer]=streaming_service
      film
    end
  end

  def self.movie_scraper(url)

    doc = Nokogiri::HTML(open("https://www.justwatch.com#{url}"))
    movie = doc.css("div.col-sm-8.col-sm-push-4")
    movie_info = {}
    array_with_name_and_year=movie.css("div.title-block").text.split(/[()]/)
    movie_info[:year] = array_with_name_and_year[1]
    info = movie.css("div.clearfix")
    info.each do |category|
      if category.css("div.detail-infos__subheading.label").text=="Genres"
        movie_info[:genre] = category.css("div.detail-infos__detail--values span").text.split(",").delete_if{|i| i==" "}.each {|g| g.strip}
      elsif category.css("div.detail-infos__subheading,label").text=="Runtime"
        movie_info[:runtime] = category.css("div.detail-infos__detail--values").text.strip
      end
    end

    movie_info[:synopsis] = movie.css("p.text-wrap-pre-line.mt-0 span").text

    movie_info
  end
end
