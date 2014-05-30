class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location
  before_filter :update_sanitized_params, if: :devise_controller?

  private

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/log_in" &&
        request.fullpath != "/create_an_account" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/log_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
  end
end
