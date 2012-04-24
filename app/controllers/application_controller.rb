class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery

  helper :all

  before_filter :set_locale

  before_filter { |c| Authorization.current_user = c.current_user }

  protected

  def permission_denied
    flash[:notice] = t('flash.authentication.notice')

    redirect_to login_path
  end

  def set_accept_header
    # We only care about browsers. IE7 & 8 set some stupid ACCEPT header. Force fix.
    accept = request.env['HTTP_ACCEPT']

    request.env['HTTP_ACCEPT'] = "application/xml,application/xhtml+xml,text/html;q=0.9,#{accept}"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"

    { :locale => I18n.locale }
  end
end
