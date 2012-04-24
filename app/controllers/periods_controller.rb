class PeriodsController < ApplicationController
  filter_access_to :all

  def index
    @periods = Period.ordered
  end

  def new
    @period = Period.new
  end

  def edit
    @period = Period.find(params[:id])
  end

  def create
    @period = Period.new(params[:period])

    if @period.save
      redirect_to periods_url, notice: t('model.period.create.ok')
    else
      render action: "new"
    end
  end

  def update
    @period = Period.find(params[:id])

    if @period.update_attributes(params[:period])
      redirect_to periods_url, notice: t('model.period.update.ok')
    else
      render action: "edit"
    end
  end

  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    redirect_to periods_url, notice: t('model.period.delete.ok')
  end
end
