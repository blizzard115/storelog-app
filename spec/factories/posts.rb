FactoryBot.define do
  factory :post do
    title { "タイトル1" }
    content { "本文1" }

    association :user, factory: :user
    store { user.store }
  end
end
