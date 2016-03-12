class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required
    unless current_user.present?
      redirect_to login_users_path
    end
  end


  private



  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
