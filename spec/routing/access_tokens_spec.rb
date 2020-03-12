require 'rails_helper'

describe 'Access Token routes' do
  it 'should route to access_tokens create action' do
    expect(post '/login').to route_to('access_tokens#create')
  end

  it "should route to access_tokens destroy action" do
    # destroying access token for /logout route
    expect(delete '/logout').to route_to('access_tokens#destroy')
  end
end
