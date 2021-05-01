Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.name          = 'rex_movie_recommendation_bot'
  s.version       = '0.0.1'
  s.summary       = "Movie Recommendations"
  s.description   = "A bot that makes movie recommendations based on input of streaming service."
  s.files         = ["config/environment.rb", "lib/scraper.rb", "lib/seek_and_destroyable.rb", "lib/streamer.rb", "lib/movie.rb", "lib/genre.rb","lib/command_line_interface.rb"]
  s.executables   << "run"
  s.require_paths = ["lib"]
  s.authors       = ["Patrick Brennan"]
  s.email         = 'pbrennanmusic@gmail.com'
  s.homepage      = "https://github.com/pbrzn/rex_movie_recommendation_bot"
  s.license       = 'MIT'
  s.requirements  << 'nokogiri'
  s.requirements  << 'open-uri'
  s.requirements  << 'require_all '
end
