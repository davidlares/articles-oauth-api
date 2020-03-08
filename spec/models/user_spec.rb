require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should have valid factory' do
      # building a user - using factory generator
      user = build :user
      expect(user).to be_valid
      # generating user from factory
    end
    it 'should validate presence of attributes' do
      user = build :user, login: nil, provider: nil
      # invalid
      expect(user).not_to be_valid
      # contain error messages
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end
    it 'should validate uniqueness of login' do
      user = create :user
      other_user = build :user, login: user.login
      expect(other_user).not_to be_valid
      other_user.login = 'newlogin'
      expect(other_user).to be_valid
    end
  end
end
