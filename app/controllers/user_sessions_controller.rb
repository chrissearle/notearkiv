# coding: UTF-8

class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def new_once
    user = User.find_by_onetime(params[:code])

    @user_session = UserSession.new(user)
    if @user_session.save
      user.clear_one_time_code

      redirect_to_target_or_default(root_url)
    else
      flash[:notice] = t('user_session.flash.onetime.warning')
      render :action => 'new'
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      User.find_by_username(params[:user_session][:username]).clear_one_time_code

      redirect_to_target_or_default(root_url)
    else
      flash[:error] = t('user_session.flash.login.error')
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    redirect_to root_url
  end

  def forgotten
  end

  def reset
    user = User.find_by_email(params[:email])

    if user
      user.send_reset_password
    end
  end
end
