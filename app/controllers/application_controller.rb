class ApplicationController < ActionController::Base

  check_authorization
  protect_from_forgery with: :exception

  layout "base"
  before_filter :set_locale_from_params
  around_filter :with_current_user

  helper_method :current_user, :current_semester, :current_language, :current_annual, :current_year, :with_format, :current_user_permission, :department_settings


  unless Rails.env.development?
    rescue_from Exception, :with => :exception_handler
  end


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

  def current_user_permission(model)
    @current_user_permission = {} unless defined?(@current_user_permission)
    return @current_user_permission[model] if @current_user_permission.has_key?(model)
    if current_user
      @current_user_permission[model] = current_ability.instance_variable_get("@rules").select do |rule|
        rule.subjects.any? {|subject| subject == Diamond::Thesis }
      end.first.try(:actions).try(:first).to_s
    else
      @current_user_permission[model] = ''
    end
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
    @settings = Settings.pick_newest
  end

  def department_settings
    return @department_settings if defined?(@department_settings)
    @department_settings = DepartmentSettings.for_department(current_user.verifable.try(:department)).for_annual(current_annual).first
  end

  def current_language
    I18n.locale
  end

  protected

  def fragment_cache_key_for(elements)
    fragment_cache_key([current_annual.name, params[:controller], params[:action],
        I18n.locale, (current_user.present? ? current_user.id : false),
        request.format, elements].flatten)
  end

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

  def exportable_format?
    request.format.pdf? || request.format.xlsx?
  end

  private
  def exception_handler(exception)
    case exception.class.to_s
    when "CanCan::AccessDenied"
      respond_to do |f|
        f.html do
          if current_user
            flash[:error] = I18n.t(:error_resource_forbidden)
            redirect_to root_path
          else
            session[:requested_url] = request.fullpath
            flash[:error] = I18n.t(:error_login_first)
            redirect_to new_user_session_path
          end
        end
        f.json do
          render :text => "403", :status => 403
        end
        f.js do
          render :text => "403", :status => 403
        end
      end
    else
    end
  end

end
