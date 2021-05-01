class Streamer
  extend SeekAndDestroyable

  attr_accessor :name, :movies, :genres
  @@all=[]

  def initialize(name)
    #binding.pry
    @name = name
    @movies = []
    @genres = []
    self.create_library
    self.genres
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def create_library
    library = Scraper.streamer_scraper(self.name)
    library.each do |movie_hash|
      new_movie = Movie.new(movie_hash)
      @movies << new_movie
      new_movie.save
    end
    @movies
  end

  def self.find_or_create_by_name(name)
    if !self.find_by_name(name)
      streamer = self.new(name)
      streamer.save
      streamer
    else
      self.find_by_name(name)
    end
  end

  def genres
    self.movies.each do |movie|
      movie.genre.each {|genre| @genres << genre.strip unless @genres.include?(genre.strip)}
    end
    @genres
  end

  def movies_by_genre(genre_name)
    genre = Genre.find_by_name(genre_name)
    genre.movies.select {|movie| movie.streamer == self.name}
  end
end
