# coding: UTF-8

class EvensongsController < ApplicationController
  layout "wide"
  
  filter_access_to :all

  before_filter :get_evensong, :only => [:show, :edit, :update, :destroy]
  before_filter :get_relation_collections, :only => [:new, :edit]

  def index
    set_accept_header

    @evensongs = Evensong.ordered.preloaded

    respond_to do |format|
      format.html # index.html.erb
                  #      format.xls do
                  #        excel = Evensong.excel

                  #        send_file(excel.get_spreadsheet,
                  #                  :type => 'application/vnd.ms-excel',
                  #                  :disposition => 'attachment',
                  #                  :filename => excel.get_filename)
                  #end
    end
  end

  def show
  end

  def new
    @evensong = Evensong.new
  end

  def create
    @evensong = Evensong.new(params[:evensong])

    if @evensong.save
      redirect_to evensongs_url, notice: t('model.evensong.create.ok')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @evensong.update_attributes(params[:evensong])
      redirect_to evensongs_url, notice: t('model.evensong.update.ok')
    else
      render :action => "edit"
    end
  end

  def destroy
    @evensong.destroy

    redirect_to evensongs_url, notice: t('model.evensong.delete.ok')
  end

  private

  def get_evensong
    @evensong = Evensong.find(params[:id])
  end

  def get_relation_collections
    @composers = Composer.ordered
    @genres = Genre.ordered
  end
end
