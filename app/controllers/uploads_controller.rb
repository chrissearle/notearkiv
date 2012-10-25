class UploadsController < ApplicationController
  before_filter :get_upload, :only => [:destroy]

  def new
    @upload = Upload.new
    @upload.note = Note.find(params[:note]) if params[:note]
    @upload.evensong = Evensong.find(params[:evensong]) if params[:evensong]
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
end
