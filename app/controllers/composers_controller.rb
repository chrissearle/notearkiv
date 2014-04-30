class ComposersController < ApplicationController
  filter_access_to :all

  before_action :set_composer, only: [:show, :edit, :update, :destroy]

  def index
    @composers = Composer.ordered
  end

  def show
  end

  def new
    @composer = Composer.new
  end

  def edit
  end

  def create
    @composer = Composer.new(composer_params)

    respond_to do |format|
      if @composer.save
        format.html { redirect_to :action => 'index', notice: t('create.composer.ok') }
        format.json { render :show, status: :created, location: @composer }
      else
        format.html { render :new }
        format.json { render json: @composer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @composer.update(composer_params)
        format.html { redirect_to :action => 'index', notice: t('update.composer.ok') }
        format.json { render :show, status: :ok, location: @composer }
      else
        format.html { render :edit }
        format.json { render json: @composer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @composer.destroy
    respond_to do |format|
      format.html { redirect_to composers_url, notice: t('delete.composer.ok') }
      format.json { head :no_content }
    end
  end

  private

  def set_composer
    @composer = Composer.find(params[:id])
  end

  def composer_params
    params.require(:composer).permit(:name)
  end
end
