require 'policy_helper'

describe UserPolicy do
  subject { UserPolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:rep) { FactoryGirl.create(:rep).user }
  let(:rep2) { FactoryGirl.create(:rep).user }
  let(:admin) { FactoryGirl.create(:user, is_admin: true) }

  permissions :edit? do
    it 'permits user to edit only their own profile' do
      expect(subject).to permit(user, user)
      expect(subject).not_to permit(user, admin)
    end
    it 'permits rep to select only their profile' do
      expect(subject).to permit(rep, rep)
      expect(subject).not_to permit(rep, rep2)
      expect(subject).not_to permit(rep, user)
    end
    it 'permits admin to edit anyones profile' do
      expect(subject).to permit(admin, admin)
      expect(subject).to permit(admin, user)
      expect(subject).to permit(admin, rep)
    end
  end

  permissions :upload_avatar? do
    it 'permits admin to upload a photo for anyone' do
      expect(subject).to permit(admin, user)
      expect(subject).to permit(admin, admin)
      expect(subject).to permit(admin, rep)
    end

    it "does not permit user to upload a photo" do
      expect(subject).not_to permit(user, user)
    end

    it 'permits rep to upload photo only for themselves' do
      expect(subject).to permit(rep, rep)
      expect(subject).not_to permit(rep, rep2)
      expect(subject).not_to permit(rep, user)
    end
  end
end
