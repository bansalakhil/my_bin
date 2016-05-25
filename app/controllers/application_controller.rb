class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :authenticate

  check_authorization

  helper_method :current_user, :signed_in?, :get_guide_titles

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to_back_or_default
  end


  protected

  def access_denied(exception)
    flash[:error] = exception.message
    redirect_to_back_or_default
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def authenticate
    if !signed_in?
      store_location
      flash[:error] = "You need to be logged in to access the requested page"
      redirect_to login_path
    end
  end

  def redirect_to_back_or_default
    redirect_to(session[:return_to] || root_path)
    session.delete(:return_to)
  end

  def store_location(url = nil)
    session[:return_to] = url || request.url
  end

end
