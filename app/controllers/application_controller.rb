class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :require_login
  before_filter :set_current_user

  def after_sign_in_path_for(resource)
    if resource.class == AdminUser
      admin_root_path
    else
      if resource.organization
        dashboard_path
      else
        new_organization_path
      end
    end
  end

#before_filter :require_login
before_filter :sign_in_redirect_hack
before_filter :redirect_if_logged_in
private
  def require_login
    unless current_user
      redirect_to '/login'
    end
  end
  
  def redirect_if_logged_in
    if current_user && current_user.is_admin? && (request.env['PATH_INFO'] == '/')
      redirect_to '/dashboard'
    end
    if current_user && !current_user.is_admin? && ((request.env['PATH_INFO'] == '/') || (request.env['PATH_INFO'] == '/dashboard'))
      redirect_to '/tasks'
    end
  end
 

  def sign_in_redirect_hack
    if controller_name != 'sessions' and current_user.blank?
      #redirect_to '/login'
    end
  end

  
  
  def set_current_user
    return true unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

end
