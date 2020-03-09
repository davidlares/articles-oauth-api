require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe '#create' do
    # helper for common (repetitive) values
    shared_examples_for "unauthorized_requests" do
      let(:error) do
        {
          # symbols needed
          "status" => "401",
          "source" => {"pointer" => "/code"},
          "title" => "Authentication code is invalid",
          "detail" => "You must provide a valid code in order to exchange it for token."
        }
      end
      # common cases
      it 'should return 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        subject
        expect(json['errors']).to include(error)
      end
    end

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
end
