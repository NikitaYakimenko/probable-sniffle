FactoryBot.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    password   { Faker::Internet.password }

    trait :archived do
      archived_at     { Time.current }
      archived_reason { Faker::Lorem.sentence }
    end
  end
end
