require 'rails_helper'

RSpec.describe Embed::QuestionsController, :type => :controller do
  # Just a simple test to make sure the embed controller/views are still working
  describe "GET #show" do
    render_views
    let(:question) { FactoryGirl.create(:question) }
    let(:response) { get :show, id: question.id }

    it "shows question" do
      expect(response).to be_success
    end
  end
end
