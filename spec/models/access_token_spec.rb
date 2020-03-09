require 'rails_helper'

RSpec.describe AccessToken, type: :model do
   describe '#validations' do
     it "should have valid factory" do
       expect(build :access_token).to be_valid
     end
     it "should validate token" do
       # uncertain problem - review it later
     end
   end

   describe '#new' do
     it 'should have a token present after initialize' do
       expect(AccessToken.new.token).to be_present
     end
     it 'should generate uniq token' do
       user = create :user
       expect{user.create_access_token}.to change{AccessToken.count}.by(1)
       expect(user.build_access_token).to be_valid
     end

     it 'should generate token once' do
       user = create :user # creating a user
       access_token = user.create_access_token
       # checking reload token vs original token
       expect(access_token.token).to eq(access_token.reload.token)
     end
   end
end
