FactoryBot.define do
  factory :user do
    uid { Faker::Alphanumeric }
  end
end
