class PagesController < ApplicationController
  after_action :verify_authorized, :only => [] # skip permissions check

  def about
  end

  def terms_of_use
  end

  def privacy_policy
  end
end