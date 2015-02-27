class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter :set_current_user

  protected

  def self.default_url_options
    {locale: I18n.locale}
  end

  def permission_denied

    logger.info 'permission_denied used'

    if current_user
      flash[:alert] = t('flash.authentication.notice')
    end

    redirect_to new_user_session_url
  end

  def set_accept_header
    # We only care about browsers. IE7 & 8 set some stupid ACCEPT header. Force fix.
    accept = request.env['HTTP_ACCEPT']

    request.env['HTTP_ACCEPT'] = "application/xml,application/xhtml+xml,text/html;q=0.9,#{accept}"
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

    {:locale => I18n.locale}
  end
end
