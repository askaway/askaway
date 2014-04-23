require 'spec_helper'

describe AnswersController do

  let(:answer) { create :answer }

  describe 'GET #show' do
    it 'response successfully' do
      expect(get :show, id: answer.id).to be_successful
    end
  end

end
