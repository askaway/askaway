class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_filter :store_location
  before_filter :check_for_invitation
  before_filter :update_sanitized_params, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/log_in" &&
        request.fullpath != "/create_an_account" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/log_out" &&
        request.fullpath =~ /\/questions\/d+\/votes/ &&
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

  def check_for_invitation
    if session[:invitation_token].present? &&
        (controller_name != 'invitations') &&
        (controller_name != 'registrations')
      redirect_to(invitation_path(session[:invitation_token]))
    end
  end

  def user_not_authorized
    flash[:error] = "Sorry, looks like you don't have permission to do that."
    redirect_to(request.referrer || root_path)
  end
end
