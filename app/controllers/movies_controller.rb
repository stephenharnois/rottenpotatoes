class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort]
    @all_ratings = Movie.all_ratings
    if params[:ratings].class == Array
      @selected_ratings = params[:ratings] ? params[:ratings] : @all_ratings
    else
      @selected_ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    end
    @title_class = " "
    @release_date_class = " "
    if !sort
      @movies = Movie.find_all_by_rating(@selected_ratings)
    else
      @title_class = "hilite" if sort == "title"
      @release_date_class = "hilite" if sort == "release_date"
      @movies = Movie.order(sort).where(:rating => @selected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
