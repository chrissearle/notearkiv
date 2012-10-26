class MessagesController < ApplicationController
  filter_access_to :all

  before_filter :get_message, :only => [:edit, :update, :destroy]

  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])

    if @message.save
      redirect_to messages_url, notice: t('model.message.create.ok')
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    if @message.update_attributes(params[:message])
      redirect_to messages_url, notice: t('model.message.update.ok')
    else
      render action: "edit"
    end
  end

  def destroy
    @message.destroy

    redirect_to messages_url, notice: t('model.message.delete.ok')
  end

  private

  def get_message
    @message = Message.find(params[:id])
  end
end
