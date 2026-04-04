FactoryBot.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    password   { Faker::Internet.password }
  end
end
