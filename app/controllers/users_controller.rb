# coding: UTF-8

class UsersController < ApplicationController
  filter_access_to :all

  before_filter :get_user, :only => [:edit, :show, :update, :destroy]

  layout "wide"

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = t('model.user.create.ok')
      redirect_to :action => "index"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t('model.user.update.ok')
      redirect_to :action => "index"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    redirect_to users_url, notice: t('model.user.delete.ok')
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

end
