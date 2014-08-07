class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_filter :store_location
  before_filter :check_for_invitation
  before_filter :update_sanitized_params, if: :inside_devise?
  before_filter :ensure_signup_complete, unless: :inside_devise?
  before_filter :set_meta_tags

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
    if session[:votes]
      session[:votes].each{|question_id, vote_id|
        vote = Vote.find(vote_id)
        vote.update_attribute(:user, current_user) if vote and !vote.user
      }
      session[:votes] = nil
    end
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
    super unless (inside_devise? || inside_active_admin?)
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
    return if inside_invitations?

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path
    end
  end

  def perform_avatar_upload(path_for_redirect: nil)
    resource_name = @resource.class.name.downcase.to_sym
    unless params[resource_name]
      flash[:alert] = 'Oops! Looks like you forgot to choose a picture to upload.'
      return render 'new_avatar'
    end
    @resource.uploaded_avatar = params[resource_name][:uploaded_avatar]
    if @resource.valid?
      @resource.select_avatar!(type: 'uploaded_avatar')
      flash[:notice] = 'Lookin good! Profile picture updated.'
      redirect_to path_for_redirect
    else
      flash[:alert] = "Oops! We couldn't update your picture. Make sure it's under 5 megabytes."
      render 'new_avatar'
    end
  end

  def set_meta_tags
    @meta_title = "Ask Away | Ask NZ's parties your questions this election"
    @meta_description = "Find out where the parties stand on the things you care about."
    # @meta_description = "See the political parties' responses to the things you care about."
    # @meta_description = "See what they're saying about the things that are important to you."
    @meta_img = ActionController::Base.helpers.asset_path('askaway-facebook.jpg')
  end
end
