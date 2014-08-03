class PagesController < ApplicationController
  after_action :verify_authorized, :only => [] # skip permissions check

  def about
  end
end
