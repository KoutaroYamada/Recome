FactoryBot.define do
  password = Faker::Internet.password

  factory :user do
    email { Faker::Internet.email }
    password { password }
    user_name { Faker::Name.name }
    profile {"aaaaaaaa"}
    profile_image_id {"1"}
    password_confirmation { password }

  end

  trait :too_long_name do
    # user_name {Faker::Lorem.characters(31)}
    user_name {"aaaaaaaaaabbbbbbbbbbcccccccccc0"}
  end

  trait :too_short_name do
    user_name {Faker::Lorem.characters(2)}
  end

  trait :no_name do
    user_name {Faker::Lorem.characters(0)}
  end

  trait :same_name do #どう表現するか後で検討する
    user_name { "山梨たか子" }
  end

  trait :no_email do
    email {""}
  end

  trait :wrong_email_format1 do #アドレスに@がない
    email {"aaaagmail.com"}
  end

  trait :wrong_email_format2 do #アドレスに.がない
    email {"aaaa@gmailcom"}
  end

  trait :too_long_profile do
    profile {Faker::Lorem.characters(301)}
  end
end
