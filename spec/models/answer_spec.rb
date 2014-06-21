require 'rails_helper'

describe Answer, :type => :model do
  it 'cannot answer question if already answered by other rep of same party' do
    question = FactoryGirl.create(:question)
    rep = FactoryGirl.create(:rep)
    rep2 = FactoryGirl.create(:rep, party: rep.party)
    FactoryGirl.create(:answer, rep: rep2, question: question)
    answer = FactoryGirl.build(:answer, rep: rep, question: question)
    expect(answer).not_to be_valid
  end
end
