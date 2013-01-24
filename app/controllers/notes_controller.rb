# coding: UTF-8

class NotesController < ApplicationController
  layout :resolve_layout

  filter_access_to :all

  before_filter :get_note, :only => [:show, :edit, :update, :destroy]
  before_filter :get_voices, :only => [:new, :edit]

  def index
    set_accept_header

    session.delete :lastsearch

    @notes = Note.ordered.preloaded

    respond_to do |format|
      format.html
      format.xls { index_excel }
    end
  end

  def show
    @show = {
        :note => @note
    }

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
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      redirect_to note_url(@note), notice: t('model.note.create.ok')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @note.update_attributes(params[:note])
      redirect_to note_url(@note), notice: t('model.note.update.ok')
    else
      render :action => "edit"
    end
  end

  def destroy
    @note.destroy

    redirect_to notes_url, notice: t('model.note.delete.ok')
  end

  def sorted
    session[:lastsort][:note] = params[:sorting].values

    render :json => 'ok'
  end

  private

  def index_excel
    excel = Note.excel

    send_file(excel.get_spreadsheet,
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment',
              :filename => excel.get_filename)
  end

  def get_note
    @note = Note.find(params[:id])
  end

  def get_voices
    @voices = Note.voices
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


