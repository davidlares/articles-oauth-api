require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe 'POST #create' do
    # helper for common (repetitive) values
    context 'when no code provided' do
      subject {post :create}
       # helpers that identifies with the name provided
      it_behaves_like "unauthorized_requests"
    end

    context 'when invalid code provided' do
      let(:github_error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(github_error)
      end
      # isolated refactor and independency for context
      subject {post :create, params: {code: 'invalid_code'}}
       # helpers that identifies with the name provided
      it_behaves_like "unauthorized_requests"
    end

    context 'when success request' do
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

      # overriding subject
      subject {post :create, params: {code: 'valid_code'}}
      it "should return 201 status code" do
        subject
        # returning created status
        expect(response).to have_http_status(:created)
      end

      it "should return proper json body" do
        # checking if the count incresses
        expect {subject}.to change {User.count}.by(1)
        # find using ORM -> login = jsmith-1
        user = User.find_by(login: 'jsmith-1')
        # checking attributes (token from DB)
        expect(json_data['attributes']).to eq({'token' => user.access_token.token})
      end
    end
  end

  # handling destroy methods
  describe 'DELETE #destroy' do

    subject {delete :destroy}

    # refactoring wih shared_examples
    context 'when no authorization header provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid authorization header provided' do
      before {request.headers['authorization'] = 'Invalid token'}
      it_behaves_like 'forbidden_requests'
    end

    context 'when valid request' do
      # variables
      let(:user) {create :user}
      let(:access_token) {user.create_access_token}

      #bearer authentication
      before {request.headers['authorization'] = "Bearer #{access_token.token}" }

      it "should return 204 status code" do
        subject
        expect(response).to have_http_status(:no_content)
      end
      it "should remove the proper access token" do
        expect {subject}.to change {AccessToken.count}.by(-1)
      end
    end
  end

end
