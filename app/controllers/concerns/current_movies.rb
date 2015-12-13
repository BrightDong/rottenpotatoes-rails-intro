module CurrentMovies
  extend ActiveSupport::Concern

private

  def set_movies
    @movies = Movie.find(session[:movies_id])
  rescue ActiveRecord::RecordNotFound
  	@movies = Movie.create
  	session[:movies_id] = @movies.id
  end
end