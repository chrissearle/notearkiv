class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter :set_current_user

  protected

  def permission_denied
    if current_user
      flash[:alert] = t('flash.authentication.notice')
    end

    redirect_to new_user_session_url
  end

  private

  def set_current_user
    Authorization.current_user = current_user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"

    { :locale => I18n.locale }
  end
end
