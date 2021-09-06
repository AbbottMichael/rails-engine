FactoryBot.define do
  factory :item do
    name { Faker::Company.name }
    description { Faker::Marketing.buzzwords }
    unit_price { 10.99 }
  end
end
