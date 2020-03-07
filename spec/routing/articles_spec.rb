require 'rails_helper'

describe 'articles routes' do
  it 'should route to article index' do
    expect(get '/articles').to route_to('articles#index')
  end
  it 'should route to article show' do
    expect(get '/show/1').to route_to('articles#show', id: '1')
  end
end
