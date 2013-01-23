# coding: UTF-8

class EvensongsController < ApplicationController

  filter_access_to :all

  before_filter :get_evensong, :only => [:show, :edit, :update, :destroy]

  layout :resolve_layout

  def index
    set_accept_header

    session.delete :lastsearch

    @evensongs = Evensong.ordered.preloaded

    respond_to do |format|
      format.html
      format.xls { index_excel }
    end
  end

  def show
    @show = {
        :evensong => @evensong
    }

    search_evensongs = []

    if session.has_key? :lastsearch
      search_evensongs = Evensong.search(session[:lastsearch]).ordered.preloaded
    else
      search_evensongs = Evensong.ordered.preloaded
    end

    if search_evensongs.size > 0
      current_index = search_evensongs.index(@evensong)

      if current_index > 0
        @show[:first] = search_evensongs.first
        @show[:previous]= search_evensongs.at(current_index - 1)
      end

      if current_index < (search_evensongs.size - 1)
        @show[:last] = search_evensongs.last
        @show[:next] = search_evensongs.at(current_index + 1)
      end
    end
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

  def index_excel
    excel = Evensong.excel

    send_file(excel.get_spreadsheet,
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment',
              :filename => excel.get_filename)
  end

  def get_evensong
    @evensong = Evensong.find(params[:id])
  end

  def resolve_layout
    case action_name
      when "index"
        "wide"
      else
        "application"
    end
  end
end

