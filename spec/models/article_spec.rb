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

  # new block for recent method (uses . because is a method)
  describe '.recent' do
    it "should list recent article first" do
      # generating articles
      old_article = create :article
      newer_article = create :article
      # expected sort
      expect(described_class.recent).to eq(
        [newer_article, old_article] # collection
      )
      # changing timestamp
      old_article.update_column :created_at, Time.now
      # repeat
      expect(described_class.recent).to eq(
        [old_article, newer_article] # collection
      )
    end
  end

end

# using #validations -> test everything that is part of an instance
# using .recent -> method find on a class - related test (like a method) but is not an instance test
