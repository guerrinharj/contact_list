require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: user.email)
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with a short password' do
      user.password = 'short'
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end
end
