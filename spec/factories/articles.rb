FactoryBot.define do
  factory :article do
    user { nil }
    url { "MyString" }
    Abbreviated_url { "MyString" }
    recommend_comment { "MyText" }
  end
end
