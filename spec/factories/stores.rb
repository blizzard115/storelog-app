FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "テスト店舗#{n}" }
    sequence(:store_code) { |n| "STORE#{n}" }
  end
end
