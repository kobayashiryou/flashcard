FactoryBot.define do
  factory :question do
    body { Faker::Lorem.sentence }
    answer { Faker::Lorem.sentence }
    user
  end
end
