class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "base"
  before_filter :set_locale_from_params
  around_filter :with_current_user

  helper_method :current_user, :current_semester, :current_language, :current_annual, :current_year, :with_format


  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_annual
    return @current_annual if defined?(@current_annual)
    @current_annual = settings.annual
  end

  def current_semester
    return @current_semester if defined?(@current_semester)
    @current_semester = settings.enrollment_semester
  end

  def settings
    return @settings if defined?(@settings)
    @settings = Settings.first
  end

  def current_language
    I18n.locale
  end

  protected
  def set_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = 'Translation not available'
        logger.error flash.now[:notice]
      end
    end
  end

  def with_current_user
    begin
      User.current = current_user
      yield
    ensure
      User.current = nil
    end
  end

  def form_wrapper_mode
    @form_wrapper_mode = true
  end

end
