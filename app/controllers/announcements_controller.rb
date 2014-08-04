class AnnouncementsController < ApplicationController
  after_action :verify_authorized, except: :dismiss
  def dismiss
    session[:announcement_dismissed] = true;
    head :ok
  end
end
