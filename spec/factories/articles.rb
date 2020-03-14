FactoryBot.define do
  factory :article do
    # changing Article fake data
    sequence(:title) {|n| "My awesome article #{n}"}  # sequence helper (makes it unique)
    sequence(:content) { |n| "The content of my awesome article #{n}" }
    sequence(:slug) { |n| "my-awesome-article-#{n}" }
    association :user
  end
end
