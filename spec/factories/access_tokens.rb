FactoryBot.define do
  factory :access_token do
    # The token is generated after initialization (there's no factory involved)
    association :user
  end
end
