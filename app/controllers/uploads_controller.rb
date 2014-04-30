class UploadsController < ApplicationController
  filter_access_to :all

  before_action :set_upload, only: [:refresh, :edit, :update, :destroy]
  before_filter :set_related_object, :only => [:new, :link]

  def create
    @upload = Upload.new(upload_params)

    respond_to do |format|
      if @upload.save
        format.html { redirect_to refresh_upload_path(@upload), notice: t('create.upload.ok') }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def refresh
    DropboxWrapper.refresh

    if @upload.note
      redirect_to note_path(@upload.note), notice: t('create.upload.ok')
    else
      redirect_to evensong_path(@upload.evensong), notice: t('create.upload.ok')
    end
  end

  def link
    if params[:path]
      @upload.path = params[:path]
      @upload.save

      if !@upload.note.nil?
        redirect_to note_path(@upload.note), notice: t('link.upload.ok')
      elsif !@upload.evensong.nil?
        redirect_to evensong_path(@upload.evensong), notice: t('link.upload.ok')
      end
    else
      @files = DropboxWrapper.refresh
    end
  end

  def edit
  end

  def update
    @upload.title = params[:upload][:title]

    respond_to do |format|
      if @upload.save
        format.html {
          if !@upload.note.nil?
            redirect_to note_path(@upload.note), notice: t('update.upload.ok')
          elsif !@upload.evensong.nil?
            redirect_to evensong_path(@upload.evensong), notice: t('update.upload.ok')
          end
        }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    note = @upload.note
    evensong = @upload.evensong

    @upload.destroy

    respond_to do |format|
      format.html {
        if note
          redirect_to note_path(note), notice: t('delete.upload.ok')
        else
          redirect_to evensong_path(evensong), notice: t('delete.upload.ok')
        end
      }
      format.json { head :no_content }
    end
  end

  private

  def set_upload
    @upload = Upload.find(params[:id])
  end

  def set_related_object
    if params[:upload]
      @upload = Upload.find(params[:upload])
    else
      @upload = Upload.new
    end

    @upload.note = Note.find(params[:note]) if params[:note]
    @upload.evensong = Evensong.find(params[:evensong]) if params[:evensong]
  end

  def upload_params
    params.require(:upload).permit(:title, :path, :note_id, :evensong_id, :uploadfile)
  end
end
