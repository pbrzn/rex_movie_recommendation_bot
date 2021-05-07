class Genre
  extend SeekAndDestroyable
  attr_accessor :name, :movies, :streamers
  @@all = []

  def initialize(name)
    @name = name
    @movies = []
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def self.find_or_create_by_movie(movie)
    movie.genre.each do |g|
      if !self.find_by_name(g)
        genre = Genre.new(g).tap do |gen|
        gen.movies << movie
        gen.save
        end
      else
        genre = self.find_by_name(g).tap do |gen|
        gen.movies << movie unless gen.movies.include?(movie)
        end
      end
    end
  end
end
