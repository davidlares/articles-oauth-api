require 'rails_helper'

RSpec.describe Article, type: :model do

  # grouping related tests
  describe '#validations' do
    # adding validation tests
    it 'should test that the factory is valid' do
      # generating fake objects for testing - article being valid
      expect(FactoryBot.build :article).to be_valid
    end
    # avoid empty articles
    it 'should validate the presence of the title' do
      article = FactoryBot.build :article, title: ''
      expect(article).not_to be_valid # being a valid title
      expect(article.errors.messages[:title]).to include ("can't be blank")
    end

    # avoid empty content
    it 'should validate the presence of the content' do
      article = FactoryBot.build :article, content: ''
      expect(article).not_to be_valid # being a valid title
      expect(article.errors.messages[:content]).to include ("can't be blank")
    end

    # avoid empty content
    it 'should validate the uniquess of the slug' do
      article = create :article # FactoryBot is called from the helper
      invalid_article = build :article, slug: article.slug # being a valid title
      expect(invalid_article).not_to be_valid
    end
  end

end
