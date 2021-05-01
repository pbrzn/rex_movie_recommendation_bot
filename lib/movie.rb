class Movie
  extend SeekAndDestroyable
  attr_accessor :name, :year, :genre, :runtime, :synopsis, :streamer, :url
  @@all = []

  def initialize(basic_info)
    @name = basic_info[:name]
    @url = basic_info[:url]
    @streamer = basic_info[:streamer]
    self.add_attributes
    self.create_genres
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def add_attributes
    attributes = Scraper.movie_scraper(self.url)
    attributes.each do |k,v|
      self.send("#{k}=", v)
    end
    self
  end

  def create_genres
    self.genre.each do |genre|
      Genre.find_or_create_by_movie(self)
    end
  end
end
