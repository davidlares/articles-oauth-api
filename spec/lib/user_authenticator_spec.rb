require 'rails_helper'

describe UserAuthenticator do
  describe '#perform' do
    # reusing object
    let(:authenticator) { described_class.new('sample_code') }
    subject {authenticator.perform}
    # block - group of tests
    context 'when code is incorrect' do
      # you can just let Octokit work with any instance and handle it returns (for tests)
      let(:error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }
      # mocking data
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end
      # raise an error
      it "should raise an error" do
        # raising an specific Auth Error
        expect{subject}.to raise_error(UserAuthenticator::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context 'when code is correct' do
      # you can just let Octokit work with any instance and handle it returns (for tests)
      # hash for data
      let(:user_data) do
        {
          login: 'jsmith-1',
          url: 'http://example.com',
          avatar_url: 'http://example.com',
          name: 'John Smith'
        }
      end
      # mocking data
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("validaccesstoken")
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      it 'should save the user when does not exists' do
        # at least one user created
        expect{subject}.to change {User.count}.by(1)
        # checking data corresponds to user
        expect(User.last.name).to eq('John Smith')
      end

      it "should reuse already registered user" do
        user = create :user, user_data
        expect {subject}.not_to change {User.count}
        expect(authenticator.user).to eq(user)
      end

      it "should create and set user's access token" do
        # grabbing access token
        expect {subject}.to change {AccessToken.count}.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
