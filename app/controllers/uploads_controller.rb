class UploadsController < ApplicationController
  before_filter :get_upload, :only => [:destroy]
  before_filter :get_related_object, :only => [:new, :link]

  def new
  end

  def create
    @upload = Upload.new(params[:upload])

    if @upload.save
      if @upload.note
        redirect_to note_path(@upload.note), notice: t('model.upload.create.ok')
      else
        redirect_to evensong_path(@upload.evensong), notice: t('model.upload.create.ok')
      end
    else
      render :action => 'new'
    end
  end

  def link
    if params[:path]
      @upload.path = params[:path]
      @upload.save

      if !@upload.note.nil?
        redirect_to note_path(@upload.note), notice: t('upload.linked')
      elsif !@upload.evensong.nil?
        redirect_to evensong_path(@upload.evensong), notice: t('upload.linked')
      end
    else
      files = DropboxWrapper.get_path('/')

      Rails.cache.write(DROPBOX_FILE_LIST_CACHE_KEY, files)
      Rails.cache.write(DROPBOX_FILE_LIST_TIMESTAMP_CACHE_KEY, DateTime.now)

      @files = Rails.cache.read(DROPBOX_FILE_LIST_CACHE_KEY)
    end
  end

  def destroy
    note = @upload.note
    evensong = @upload.evensong

    @upload.destroy

    if note
      redirect_to note_path(note), notice: t('model.upload.delete.ok')
    else
      redirect_to evensong_path(evensong), notice: t('model.upload.delete.ok')
    end
  end

  private

  def get_upload
    @upload = Upload.find(params[:id])
  end

  def get_related_object
    @upload = Upload.new
    @upload.note = Note.find(params[:note]) if params[:note]
    @upload.evensong = Evensong.find(params[:evensong]) if params[:evensong]
  end
end
