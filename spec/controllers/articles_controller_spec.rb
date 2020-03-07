require 'rails_helper'

describe ArticlesController do
  # testing index controller method
  subject {get :index}
  describe '#index' do
    it "should return success response" do
      subject
      # check the responses.png
      expect(response).to have_http_status(:ok)
    end
  end
  describe '#index' do
    it "should return proper json" do
      articles = create_list :article, 2
      subject
      # expecting 2 elements
      expect(json_data.length).to eq(2)
      # expecting this data
      articles.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq({
            "title" => article.title,
            "content" => article.content,
            "slug" => article.slug
        })
      end
    end
  end
end
