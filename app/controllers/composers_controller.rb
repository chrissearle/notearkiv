class ComposersController < ApplicationController
  filter_access_to :all

  def index
    @composers = Composer.ordered
  end

  def new
    @composer = Composer.new
  end

  def edit
    @composer = Composer.find(params[:id])
  end

  def create
    @composer = Composer.new(params[:composer])

    if @composer.save
      redirect_to composers_url, notice: t('model.composer.create.ok')
    else
      render action: "new"
    end
  end

  def update
    @composer = Composer.find(params[:id])

    if @composer.update_attributes(params[:composer])
      redirect_to composers_url, notice: t('model.composer.update.ok')
    else
      render action: "edit"
    end
  end

  def destroy
    @composer = Composer.find(params[:id])
    @composer.destroy

    redirect_to composers_url, notice: t('model.composer.delete.ok')
  end
end
