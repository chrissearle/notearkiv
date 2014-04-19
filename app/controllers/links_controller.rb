class LinksController < ApplicationController
  filter_access_to :all

  before_action :set_link, only: [:edit, :update, :destroy]


  def new
    @link = Link.new
    @link.note = Note.find(params[:note]) if params[:note]
    @link.evensong = Evensong.find(params[:evensong]) if params[:evensong]
  end

  def edit
  end

  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html do
          if @link.note
            redirect_to note_path(@link.note)
          else
            redirect_to evensong_path(@link.evensong)
          end
        end
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @link.title = params["link"]["title"]
    @link.url = params["link"]["url"]

    respond_to do |format|
      if @link.update(link_params)
        format.html do
          if @link.note
            redirect_to note_path(@link.note)
          else
            redirect_to evensong_path(@link.evensong)
          end
        end
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    note = @link.note
    evensong = @link.evensong

    @link.destroy

    respond_to do |format|
      format.html do
        if note
          redirect_to note_path(note)
        else
          redirect_to evensong_path(evensong)
        end
      end
      format.json { head :no_content }
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
