require 'nokogiri'
require 'open-uri'

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
    movie = doc.css("div.title-block__container")
    movie_info = {}
    name_and_year=movie.css("div.title-block").text.split(/[()]/)
    movie_info[:year] = name_and_year[1]
    info = doc.css("div.detail-infos div.detail-infos__detail div.clearfix")
    info.each do |category|
      if category.css("div.detail-infos__subheading.label").text=="Genres"
        movie_info[:genre] = category.css("div.detail-infos__detail--values span").text.split(",").delete_if{|i| i==" "}.map{|i| i.strip}
      elsif category.css("div.detail-infos__subheading.label").text==" Runtime "
        movie_info[:runtime] = category.css("div.detail-infos__detail--values").text.strip
      end
    end
    movie_info[:synopsis] = doc.css("div.col-sm-8 p.text-wrap-pre-line span").text
    movie_info
  end
end
