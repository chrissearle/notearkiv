class EvensongsController < ApplicationController
  filter_access_to :all

  before_action :set_evensong, only: [:show, :edit, :update, :destroy]

  def index
    set_accept_header

    session.delete :lastsearch

    @evensongs = Evensong.ordered.preloaded

    respond_to do |format|
      format.html { redirect_to typedsearch_url( :type => 'evensong' ) }
      format.xls { index_excel }
    end
  end

  def show
    @show = {
        :evensong => @evensong
    }
=begin
    search_evensongs = []

    joins = []

    if session[:lastsort].has_key? :evensong
      order_clause = session[:lastsort][:evensong].map do |sort|
        col = sort['column']

        if col == 'composer'
          col = "composers.name"
          joins << :composer
        end

        if col == 'genre'
          col = "genres.name"
          joins << :genre
        end

        if col == 'psalm'
          "#{col} #{sort['direction']}"
        else
          "LOWER(#{col}) #{sort['direction']}"
        end
      end.join ","

      unless order_clause.include?("title")
        order_clause += ",LOWER(evensongs.title) ASC"
      end
    else
      order_clause = "LOWER(title) ASC"
    end

    query = Evensong.order(order_clause)

    if joins.size > 0
      joins.each do |joined|
        query = query.joins(joined)
      end
    end

    if session.has_key? :lastsearch
      search_evensongs = query.search(session[:lastsearch]).preloaded
    else
      search_evensongs = query.preloaded
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
=end
  end

  def new
    @evensong = Evensong.new
  end

  def edit
  end

  def create
    @evensong = Evensong.new(evensong_params)

    respond_to do |format|
      if @evensong.save
        format.html { redirect_to evensongs_url, notice: t('create.evensong.ok') }
        format.json { render :show, status: :created, location: @evensong }
      else
        format.html { render :new }
        format.json { render json: @evensong.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @evensong.update(evensong_params)
        format.html { redirect_to evensongs_url, notice: t('update.evensong.ok') }
        format.json { render :show, status: :ok, location: @evensong }
      else
        format.html { render :edit }
        format.json { render json: @evensong.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @evensong.destroy
    respond_to do |format|
      format.html { redirect_to evensongs_url, notice: t('delete.evensong.ok') }
      format.json { head :no_content }
    end
  end

=begin
  def sorted
    session[:lastsort][:evensong] = params[:sorting].values

    render :json => 'ok'
  end
=end

  private

  begin
    def index_excel
      excel = Evensong.excel

      send_file(excel.get_spreadsheet,
                :type => 'application/vnd.ms-excel',
                :disposition => 'attachment',
                :filename => excel.get_filename)
    end
  end

  def set_evensong
    @evensong = Evensong.find(params[:id])
  end

  def evensong_params
    params.require(:evensong).permit(:title, :psalm, :soloists, :comment, :composer_id, :genre_id)
  end
end
