require 'rails_helper'

describe 'articles routes' do
  it 'should route to article index' do
    expect(get '/articles').to route_to('articles#index')
  end
  it 'should route to article show' do
    # fixing typo here (show/1 to articles/1)
    expect(get '/articles/1').to route_to('articles#show', id: '1')
  end
end
