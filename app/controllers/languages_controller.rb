class LanguagesController < ApplicationController
  filter_access_to :all

  def index
    @languages = Language.ordered
  end

  def show
    @language = Language.find(params[:id])
  end

  def new
    @language = Language.new
  end

  def edit
    @language = Language.find(params[:id])
  end

  def create
    @language = Language.new(params[:language])

    if @language.save
      redirect_to languages_url, notice: t('model.language.create.ok')
    else
      render action: "new"
    end
  end

  def update
    @language = Language.find(params[:id])

    if @language.update_attributes(params[:language])
      redirect_to languages_url, notice: t('model.language.update.ok')
    else
      render action: "edit"
    end
  end

  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    redirect_to languages_url, :notice => t('model.language.delete.ok')
  end
end
