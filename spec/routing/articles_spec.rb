require 'rails_helper'

describe 'articles routes' do
  it 'should route to article index' do
    expect(get '/articles').to route_to('articles#index')
  end
  it 'should route to article show' do
    # fixing typo here (show/1 to articles/1)
    expect(get '/articles/1').to route_to('articles#show', id: '1')
  end
  # articles list
  it "should route to articles create" do
    expect(post '/articles').to route_to('articles#create')
  end
  # updating (unified)
  it 'should route to articles update' do
    expect(put '/articles/1').to route_to('articles#update', id: '1')
    expect(patch '/articles/1').to route_to('articles#update', id: '1')
  end
  # deleting
  it "should route to articles destroy" do
    expect(delete, '/articles/1').to route_to('articles#destroy', id: '1')
  end
end
