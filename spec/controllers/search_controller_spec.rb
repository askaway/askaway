require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  let(:question){ FactoryGirl.create(:question, body: "Wes Anderson biodiesel.") }
  let(:bad_question){ FactoryGirl.create(:question, body: "What the fuck") }
  let(:answer){ FactoryGirl.create(:answer, body: "Wes Anderson biodiesel.") }

  describe "GET 'index'" do
    let(:query) { '' }
    let(:format){ 'html' }
    before { get :index, q: query, format: format }

    it{ expect(response).to be_success }
    it{ expect(response).to render_template('search/index')}

    context '.json' do
      let(:format){ 'json' }
      it{ expect(response).to be_success }
      it{ expect(response).to render_template('questions/index')}
    end

    context 'matches question body' do
      let(:query){ "Wes Anderson" }
      it{ expect(assigns(:questions)).to include(question) }
      it{ expect(assigns(:questions)).to include(answer.question) }
      it{ expect(assigns(:questions)).not_to include(bad_question) }
    end
  end

end
