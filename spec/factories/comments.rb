FactoryBot.define do
  factory :comment do
    content { "MyText" }
    articles { nil }
    user { nil }
  end
end
