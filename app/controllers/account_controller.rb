class AccountController < ApplicationController
  filter_access_to :all

  before_action :set_account, only: [:index, :edit, :update]

  def index
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(account_params)
        format.html { redirect_to :action => 'index' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_account
    @user = User.where(:username => current_user.username).first
  end

  def account_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

end