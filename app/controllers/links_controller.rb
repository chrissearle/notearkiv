class LinksController < ApplicationController
  before_filter :get_link, :only => [:edit, :update, :destroy]

  def new
    @link = Link.new
    @link.note = Note.find(params[:note]) if params[:note]
    @link.evensong = Evensong.find(params[:evensong]) if params[:evensong]
  end

  def create
    @link = Link.new(params[:link])

    if @link.save
      if @link.note
        redirect_to note_path(@link.note), notice: t('model.link.create.ok')
      else
        redirect_to evensong_path(@link.evensong), notice: t('model.link.create.ok')
      end
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @link.title = params["link"]["title"]
    @link.url = params["link"]["url"]

    if @link.save
      if @link.note
        redirect_to note_path(@link.note), notice: t('model.link.update.ok')
      else
        redirect_to evensong_path(@link.evensong), notice: t('model.link.update.ok')
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    note = @link.note
    evensong = @link.evensong

    @link.destroy

    if note
      redirect_to note_path(note), notice: t('model.link.delete.ok')
    else
      redirect_to evensong_path(evensong), notice: t('model.link.delete.ok')
    end
  end

  private

  def get_link
    @link = Link.find(params[:id])
  end
end
