class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_customer

  before_filter :set_locale

  private
  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def current_customer_session
    return @current_customer_session if defined?(@current_customer_session)
    @current_customer_session = CustomerSession.find
  end
  
  def current_customer
    return @current_customer if defined?(@current_customer)
    @current_customer = current_customer_session && current_customer_session.record
  end

  # CanCan needs it
  alias_method :current_user, :current_customer
  alias_method :current_session, :current_customer_session

  rescue_from CanCan::AccessDenied do |exception|
    if current_customer
      redirect_to access_denied_path
    else
      redirect_to login_path
    end
  end
end
