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
    @all_ratings = Movie.pluck(:rating).uniq
    # @movies = Movie.find(:all, :order => (params[:sort]))
    @hilite_column = params[:sort]
    @movies = Movie.all
    
    if params[:ratings] && params[:sort]
      @movies = Movie.where(rating: params[:ratings].keys).all.order(params[:sort])
    elsif params[:ratings]
      @movies = Movie.where(rating: params[:ratings].keys)
      session[:ratings] = params[:ratings]
    elsif params[:sort]
      @movies = Movie.all.order(params[:sort])
      session[:sort] = params[:sort]
    elsif session[:ratings] && session[:sort]
      # @ratings = session[:ratings]
      # @sort = session[:sort]
      flash.keep
      redirect_to movies_path :ratings => session[:ratings], :sort => session[:sort]
    elsif session[:ratings]
      flash.keep
      redirect_to movies_path :ratings => session[:ratings]
    elsif session[:sort] 
      flash.keep
      redirect_to movies_path  :sort => session[:sort]
    end
    
    @set_rating = false
    
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
