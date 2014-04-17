class PeriodsController < ApplicationController
  before_action :set_period, only: [:show, :edit, :update, :destroy]

  def index
    @periods = Period.ordered
  end

  def show
  end

  def new
    @period = Period.new
  end

  def edit
  end

  def create
    @period = Period.new(period_params)

    respond_to do |format|
      if @period.save
        format.html { redirect_to :action => 'index' }
        format.json { render :show, status: :created, location: @period }
      else
        format.html { render :new }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @period.update(period_params)
        format.html { redirect_to :action => 'index' }
        format.json { render :show, status: :ok, location: @period }
      else
        format.html { render :edit }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @period.destroy
    respond_to do |format|
      format.html { redirect_to periods_url }
      format.json { head :no_content }
    end
  end

  private

  def set_period
    @period = Period.find(params[:id])
  end

  def period_params
    params.require(:period).permit(:name)
  end
end
