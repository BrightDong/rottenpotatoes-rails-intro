class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

	  @all_ratings = Movie.all_ratings
    @sort = nil
    @filter = nil


    ################  Extract info from params  #############################
    #### with params sort
    if params[:sort]
      @sort = session[:sort] = params[:sort]
    ####   with params filter rating  
    elsif params[:ratings]
      @filter = []
      params[:ratings].each do |key, value|
        @filter << key
      end
      session[:filter] = @filter
    end

    ################  Extract info from session  #############################
    if @filter == nil && session[:filter] != nil
      @filter = session[:filter]
    end 
    if @sort == nil && session[:sort] != nil
      @sort = session[:sort]
    end

    ###########  Highlight the head of sorted column  ########################
    if @sort == 'title'
      @title_class = 'hilite'
    elsif @sort == 'release_date'
      @release_class = 'hilite'
    end

    ###########  set @movies according to @sort and @filter  ###################
    if @sort != nil && @filter != nil
      @movies = Movie.rating_filtered(@filter).order(@sort)
    elsif @filter != nil
      @movies = Movie.rating_filtered(@filter)
    elsif @sort != nil
      @movies = Movie.order(@sort)
    else
      @movies = Movie.all
    end          

  end

  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
