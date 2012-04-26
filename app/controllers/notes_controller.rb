# coding: UTF-8

class NotesController < ApplicationController
  layout "wide"

  filter_access_to :all

  before_filter :get_note, :only => [:show, :edit, :update, :destroy]
  before_filter :get_voices, :only => [:new, :edit]
  before_filter :get_relation_collections, :only => [:new, :edit]

  def index
    set_accept_header

    @notes = Note.ordered.preloaded

    respond_to do |format|
      format.html # index.html.erb
                  #TODO      format.xls { index_excel }
    end
  end

  def import
  end

  def show
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      redirect_to notes_url, notice: t('model.note.create.ok')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @note.update_attributes(params[:note])
      redirect_to notes_url, notice: t('model.note.update.ok')
    else
      render :action => "edit"
    end
  end

  def destroy
    @note.destroy

    redirect_to notes_url, notice: t('model.note.delete.ok')
  end

  private

#  def index_excel
#    excel = Note.excel

#    send_file(excel.get_spreadsheet,
#              :type => 'application/vnd.ms-excel',
#              :disposition => 'attachment',
#              :filename => excel.get_filename)
#  end

  def get_note
    @note = Note.find(params[:id])
  end

  def get_voices
#TODO fetch and set typeahead in the form view
  end

  def get_relation_collections
    @composers = Composer.ordered.preloaded
    @genres = Genre.ordered.preloaded
    @periods = Period.ordered.preloaded
  end
end

