FactoryBot.define do
  factory :transaction do
    credit_card_number { "4654405418249632" }
    credit_card_expiration_date { "04/23" }
    result { "success" }
  end
end
