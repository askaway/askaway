class SitemapsController < ApplicationController
  after_action :verify_authorized, :only => [] # skip authorizatio
  def show
    redirect_to "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"
  end
end
