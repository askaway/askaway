class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_filter :store_location
  before_filter :check_for_invitation
  before_filter :update_sanitized_params, if: :inside_devise?
  before_filter :ensure_signup_complete, unless: :inside_devise?

  after_action :verify_authorized, :except => :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    # TODO: replace with checking controller name (less likely to change than path)
    if (request.fullpath != "/log_in" &&
        request.fullpath != "/create_an_account" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/log_out" &&
        # FIXME: I assume below is broken cause the path changed
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
    if session[:invitation_token].present? && !inside_devise? && !inside_invitations?
      redirect_to(invitation_path(session[:invitation_token]))
    end
  end

  def user_not_authorized
    flash[:alert] = "Sorry, looks like you don't have permission to do that."
    redirect_to(request.referrer || root_path)
  end

  def verify_authorized
    super unless (inside_devise? || inside_invitations? || inside_active_admin?)
  end

  def inside_devise?
    devise_controller?
  end

  def inside_invitations?
    controller_name == 'invitations'
  end

  def inside_active_admin?
    self.class.superclass.superclass.name == 'ActiveAdmin::BaseController'
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path
    end
  end
end
