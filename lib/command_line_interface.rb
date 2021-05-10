class CommandLineInterface

  attr_accessor :streamer

  @@popular_streamers = ["Netflix","Hulu","Amazon Prime Video","Disney Plus","HBO Max","Criterion Channel"]
  @@all_streamers = ["Netflix","Netflix Kids","Hulu","Amazon Prime Video","Disney Plus","HBO Max","Criterion Channel","Apple TV Plus","Paramount Plus","Peacock","Peacock Premium","Google Play Movies","YouTube","Shudder","Hoopla","Kanopy","Funimation Now","IMDB TV","Vudu","Redbox","AMC Theaters","Popcornflix","Mubi","Starz","Showtime","Max Go","IndieFlix","TCM","Crunchyroll","Sun Nxt","Crackle","Fandor","AMC Theaters","Retrocrush","Classix","Filmrise","Film Movement Plus"]

  def run
    puts "Hello, my name is Rex: The Movie Recommendation Bot!"
    puts "Having trouble picking a movie to watch? I can help you with that!"
    puts "Just name a streaming service (and genre, if you'd like) and I'll make a recommendation from a collection of their most popular titles."
    puts "Want me to give you a recommendation? (y/n)"
    self.prompt
  end

  def prompt
    initial_prompt = gets.strip
    case initial_prompt
    when "n"
      puts "Okay. Feel free to open me up next time you're picking a movie!"
      exit
    when "y"
      puts "Awesome. I'm happy to help! Please pick a streaming service."
      puts "(By the way, you can end the program at any time by simply typing \"end\" below!)"
      self.streamer_prompt
    else
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
        self.prompt
      end
    end
  end

  def streamer_prompt
    puts "Here are some of your options..."
    @@popular_streamers.each {|streamer| puts "#{streamer}"}
    puts "If you would like a list of all available streamers, type 'list streamers'..."
    puts "...otherwise please type in the name of the streaming service you would like me to sift through."
    self.pick_streamer
  end

  def pick_streamer
    @streamer_input = gets.strip
    if @streamer_input == "list streamers"
      puts "Okay, here are all available streamers as of today..."
      @@all_streamers.each {|streamer| puts "#{streamer}"}
      puts "Which streaming service would you like to choose?"
      self.pick_streamer
    elsif @streamer_input == "end"
      puts "Okay, feel free to open me up whenever you need help picking a movie! Goodbye."
      exit
    elsif !@@all_streamers.detect {|s| s == @streamer_input}
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
      end
      self.pick_streamer
    else
      puts "Okay, just give me one moment..."
      @streamer = Streamer.find_or_create_by_name(@streamer_input)
      self.abc_prompt
    end
  end

  def abc_prompt
    puts "Great! If you want I can either:"
    puts "A: List the 30 most popular movies on #{@streamer_input},"
    puts "B: List all genres available on #{@streamer_input} to help narrow down your choices,"
    puts "or C: Make a recommendation right off the bat!"
    puts "Which option would you like to choose: A, B or C?"
    self.pick_abc
  end

  def pick_abc
    abc_input = gets.strip
    case abc_input
    when "A"
      self.list_movies
    when "B"
      self.list_genres

    when "C"
      self.make_recommendation

    when "end"
      puts "Okay, feel free to open me up whenever you need help picking a movie! Goodbye."
      exit

    else
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
        self.pick_abc
      end
    end
  end

  def list_movies
    num = 1
    movies = Movie.all.select {|movie| movie.streamer == @streamer_input}
    movies.each do |movie|
      puts "* #{movie.name}"
      num+=1
    end
    puts "Would you like me to recommend something from this list? (y/n)"
    self.movie_choice
  end

  def movie_choice
    input = gets.strip
    case input
    when "y"
      self.make_recommendation
    when "n"
      puts "Okay, why don't you try picking another streaming service..."
      self.streamer_prompt
    when "end"
      puts "Okay, feel free to open me up whenever you need help picking a movie! Goodbye."
      exit
    else
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
        self.movie_choice
      end
    end
  end

  def list_genres
    puts "Okay, which genre would you like to choose? Here are your options..."
    num=1
    self.streamer.genres.each do |genre|
      puts "* #{genre}"
      num+=1
    end
    puts "Please type the name of the genre from which you would like me to base my recommendation below."
    self.pick_genre
  end

  def pick_genre
    @genre_input = gets.strip
    if @genre_input == "end"
      puts "Okay, feel free to open me up whenever you need help picking a movie! Goodbye."
      exit
    elsif !self.streamer.genres.detect {|genre| genre == @genre_input}
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
        self.pick_genre
      end
    else
      self.make_recommendation_by_genre
    end
  end

  def make_recommendation
    puts "Okay, here is the movie I'd like to recommend to you..."
    last = (self.streamer.movies.length-1)
    rec = self.streamer.movies[rand(0..last)]
    puts "..."
    puts ""
    puts "\"#{rec.name}\""
    puts ""
    puts "Year: #{rec.year}"
    puts "Genre: #{rec.genre.join(", ")}"
    puts "Runtime: #{rec.runtime}" unless rec.runtime == nil
    puts "Synopsis: \"#{rec.synopsis}\""
    puts "..."
    self.postscript
  end

  def make_recommendation_by_genre
    @genre_movies = self.streamer.movies_by_genre(@genre_input)
    last = (@genre_movies.length-1)
    if last > 1
      @genre_rec = @genre_movies[rand(0..last)]
    else
      @genre_rec = @genre_movies[0]
    end
    puts "Okay, here is your #{@genre_input} film..."
    puts "..."
    puts ""
    puts "\"#{@genre_rec.name}\""
    puts ""
    puts "Year: #{@genre_rec.year}"
    puts "Genre: #{@genre_rec.genre.join(", ")}"
    puts "Runtime: #{@genre_rec.runtime}" unless @genre_rec.runtime == nil
    puts "Synopsis: \"#{@genre_rec.synopsis}\""
    puts "..."
    self.postscript
  end

  def postscript
    puts "I hope you like it! If you'd like another recommendation, just type the word \"recommend\" below."
    puts "Or if you'd like to start from scratch with a new streamer, just type the word \"rerun\"."
    puts "If you like this recommendation, you can close the program by simply typing \"end\"."
    self.postscript_input
  end

  def postscript_input
    input = gets.strip
    case input
    when "recommend"
      if @genre_input != nil && @genre_movies.length > 1
        puts "No problem. Do you want to stick with the same genre? (y/n)"
        new_input = gets.strip
        if new_input == "y"
          self.make_recommendation_by_genre
        elsif new_input == "n"
          self.list_genres
        end
      elsif @genre_input != nil && @genre_movies.length == 1
        puts "Unfortunately there is only one #{@genre_input} film on #{@streamer_input}."
        puts "Would you like to choose a new genre? (y/n)"
        new_input = gets.strip
        if new_input == "y"
          self.list_genres
        elsif new_input == "n"
          self.abc_prompt
        end
      else
        self.make_recommendation
      end
    when "rerun"
      @genre_input = nil
      self.streamer_prompt
    when "end"
      puts "Thanks. Enjoy the movie!"
      exit
    else
      begin
        raise InvalidInputError
      rescue InvalidInputError => error
        puts error.message
        self.postscript_input
      end
    end
  end

  class InvalidInputError < StandardError
    def message
      "Your input is invalid. Please check for spelling, capitalization and/or spaces. Lets try again..."
    end
  end
end
