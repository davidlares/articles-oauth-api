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
      create_list :article, 2
      subject
      # expecting 2 elements
      expect(json_data.length).to eq(2)
      # expecting this data
      Article.recent.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq({
            "title" => article.title,
            "content" => article.content,
            "slug" => article.slug
        })
      end
    end
    it "should return articles in the proper order" do
        # rendering articles in newest to oldest
        old_article = create :article
        newer_article = create :article
        subject
        # newest first
        expect(json_data.first['id']).to eq(newer_article.id.to_s)
        expect(json_data.last['id']).to eq(old_article.id.to_s)
    end
    # pagination results
    it "should paginate results" do
      create_list :article, 3
      get :index, params: {page: 2, per_page: 1}
      expect(json_data.length).to eq 1
      expect(json_data.first['id']).to eq(Article.recent.second.id.to_s)
    end
  end
end
