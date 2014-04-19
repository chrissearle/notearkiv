class NotesController < ApplicationController
  filter_access_to :all

  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :set_voice, only: [:new, :edit]

  def index
    set_accept_header

#    session.delete :lastsearch

    @notes = Note.ordered.preloaded

    respond_to do |format|
      format.html
#      format.xls { index_excel }
    end
  end

  def show
    @show = {
        :note => @note
    }
=begin
    search_notes = []

    joins = []

    if session[:lastsort].has_key? :note
      order_clause = session[:lastsort][:note].map do |sort|
        col = sort['column']

        if col == 'composer'
          col = "composers.name"
          joins << :composer
        end

        if col == 'genre'
          col = "genres.name"
          joins << :genre
        end

        if col == 'period'
          col = "periods.name"
          joins << :period
        end

        if col == 'language'
          col = "languages.name"
          joins << :language
        end

        "LOWER(#{col}) #{sort['direction']}"
      end.join ","

      unless order_clause.include?("title")
        order_clause += ",LOWER(notes.title) ASC"
      end
    else
      order_clause = "LOWER(title) ASC"
    end

    query = Note.order(order_clause)

    if joins.size > 0
      joins.each do |joined|
        query = query.joins(joined)
      end
    end

    if session.has_key? :lastsearch
      search_notes = query.search(session[:lastsearch]).preloaded
    else
      search_notes = query.preloaded
    end

    if search_notes.size > 0
      current_index = search_notes.index(@note)

      if current_index > 0
        @show[:first] = search_notes.first
        @show[:previous]= search_notes.at(current_index - 1)
      end

      if current_index < (search_notes.size - 1)
        @show[:last] = search_notes.last
        @show[:next] = search_notes.at(current_index + 1)
      end
    end
=end
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to :action => 'index' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to :action => 'index' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
    end
  end

=begin
  def sorted
    session[:lastsort][:note] = params[:sorting].values

    render :json => 'ok'
  end
=end

  private

=begin
  def index_excel
    excel = Note.excel

    send_file(excel.get_spreadsheet,
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment',
              :filename => excel.get_filename)
  end
=end

  def set_note
    @note = Note.find(params[:id])
  end

  def set_voice
    @voices = Note.voices
  end

  def note_params
    params.require(:note).permit(:name)
  end
end
