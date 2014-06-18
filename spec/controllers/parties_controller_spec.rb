require 'rails_helper'

describe PartiesController, :type => :controller do
  let(:party) { FactoryGirl.build_stubbed(:party) }

  before do
    allow(Party).to receive(:find).with(party.id.to_s).and_return(party)
    # Do not test authorization here. We test it in spec/policies.
    allow(controller).to receive(:authorize).with(party).and_return(true)
    allow(controller).to receive(:verify_authorized)
  end

  describe "GET #show" do
    before{ get :show, id: party.id }

    it { expect(response).to render_template(:show) }
    it { expect(assigns(:party)).to eq(party)}
  end

  describe "GET #new_members" do
    before{ get :new_members, id: party.id }

    it { expect(response).to render_template(:new_members) }
  end

  describe "GET #invited_members" do
    before{ get :invited_members, id: party.id }

    it { expect(response).to render_template(:invited_members) }
  end

  describe "GET #walkthrough" do
    before{ get :walkthrough, id: party.id }

    it { expect(response).to render_template(:walkthrough) }
  end

  describe "POST #invite_members" do
    let(:emails) { 'jo@example.org, "Meg Howie" <meg@askaway.org.nz>' }
    let(:inviter) { FactoryGirl.build_stubbed(:inviter) }
    let(:response) { post :invite_members, id: party.id,
                          invite_members_form: { emails: emails } }

    before do
      allow(Invitation).to receive(:batch_invite!)
      allow(controller).to receive(:current_user).and_return(inviter)
    end

    it { expect(response).to redirect_to(party_path(party)) }

    it "tries to create invitations" do
      expect(Invitation).to receive(:batch_invite!).with(emails: emails,
                                                   intent: 'to_join_party',
                                                   invitable: party,
                                                   inviter: inviter)
      response
    end

    context 'on success' do
      before { allow(Invitation).to receive(:batch_invite!).and_return([double(:invitaiton)]) }

      it "sets flash notice" do
        response
        expect(flash[:notice]).to match('invited')
      end
    end

    context 'on failure' do
      before { allow(Invitation).to receive(:batch_invite!).and_return(false) }

      it "sets flash alert" do
        response
        expect(flash[:alert]).to match('could not be invited')
      end
    end
  end
end
