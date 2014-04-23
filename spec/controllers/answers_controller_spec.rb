require 'spec_helper'

describe AnswersController do

  let(:question) { create :question }

  describe 'GET #show' do
    it 'response successfully' do
      expect(get :show, question).to be_successful
    end
  end

end
