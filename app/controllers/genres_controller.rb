class GenresController < ApplicationController
  filter_access_to :all

  def index
    @genres = Genre.ordered
  end

  def show
    @genre = Genre.find(params[:id])
  end

  def new
    @genre = Genre.new
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def create
    @genre = Genre.new(params[:genre])

    if @genre.save
      redirect_to genres_url, notice: t('model.genre.create.ok')
    else
      render action: "new"
    end
  end

  def update
    @genre = Genre.find(params[:id])

    if @genre.update_attributes(params[:genre])
      redirect_to genres_url, notice: t('model.genre.update.ok')
    else
      render action: "edit"
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy

    redirect_to genres_url, notice: t('model.genre.delete.ok')
  end
end
